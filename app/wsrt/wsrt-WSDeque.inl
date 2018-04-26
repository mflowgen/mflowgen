//========================================================================
// wsrt-WSDeque.inl
//========================================================================

#include "common.h"

namespace wsrt {

  template< typename ItemType >
  WSDeque< ItemType >::WSDeque()
  {
    DequeHead init_head;
    DequeTail init_tail;

    init_head.node_ptr = &nodes[node_counter++];

    //init_head.node_ptr->next_ptr = NULL;
    //init_head.node_ptr->prev_ptr = NULL;

    init_tail.node_ptr = init_head.node_ptr;

    init_head.index = 0;
    init_tail.index = 0;

    init_head.tag = 0;

    m_head = init_head;
    m_tail = init_tail;
  }

  template< typename ItemType >
  int WSDeque< ItemType >::get_ntasks()
  {
    return m_task_count;
  }

  template< typename ItemType >
  bool WSDeque< ItemType >::is_empty()
  {
    if ( m_head.node_ptr == m_tail.node_ptr &&
         ( m_head.index == m_tail.index || m_head.index == m_tail.index + 1 ) ) {
      return true;
    } 
    //else if ( m_head.node_ptr == m_tail.node_ptr->next_ptr &&
    //            m_head.index == 0 && m_tail.index == deque_node_size - 1 ) {
    //  return true;
    //} 
    //else {
    return false;
    //}
  }

  //----------------------------------------------------------------------
  // TaskQueue::enqueue_tail
  //----------------------------------------------------------------------
  // Push a task to the task queue's tail. This operation only called by
  // the owner thread.

  template< typename ItemType >
  bool WSDeque< ItemType >::enqueue_tail( const ItemType& task )
  {
    // Read current tail position
    DequeTail current_tail = m_tail;
    DequeTail new_tail = current_tail;
    // put the task into the task queue
    current_tail.node_ptr->task_array[current_tail.index] = task;
    // Generate the new tail position
    asm volatile("": : :"memory");
    if ( current_tail.index < deque_node_size - 1 ) {
      new_tail.index++;
    } else {
      // Allocate a new node and link it to current node if needed
      //if ( current_tail.node_ptr->next_ptr == NULL ) {
      //  new_tail.node_ptr = &nodes[node_counter++];
      //  new_tail.node_ptr->next_ptr = NULL;
      //  new_tail.node_ptr->prev_ptr = current_tail.node_ptr;
      //  current_tail.node_ptr->next_ptr = new_tail.node_ptr;
      //  new_tail.index = 0;
      //} else {
      //  new_tail.node_ptr = current_tail.node_ptr->next_ptr;
      //  new_tail.index = 0;
      //}
      return false;
    }
    // Update the tail
    asm volatile("": : :"memory");
    __sync_fetch_and_add( &m_task_count, 1 );
    m_tail = new_tail;
    return true;
  }

  //----------------------------------------------------------------------
  // TaskQueue::dequeue_tail
  //----------------------------------------------------------------------
  // Pop a task from the tail. Only called by the owner thread.

  template< typename ItemType >
  bool WSDeque< ItemType >::dequeue_tail( ItemType & task )
  {
    // read old tail state.
    DequeTail old_tail = m_tail;
    DequeTail new_tail = old_tail;

    // Decide whether or not need to move to the previous node.
    if ( old_tail.index > 0 ) {
      new_tail.index--;
    } 
    //else if ( old_tail.node_ptr->prev_ptr != NULL ) {
    //  new_tail.node_ptr = old_tail.node_ptr->prev_ptr;
    //  new_tail.index    = deque_node_size - 1;
    //}

    asm volatile("": : :"memory");
    // Get the task content and update the tail
    task = new_tail.node_ptr->task_array[new_tail.index];
    m_tail = new_tail;
    // Read head info
    DequeHead current_head = m_head;
    asm volatile("": : :"memory");
    // After updating the tail, see if there is collision
    if ( old_tail.index == current_head.index &&
         old_tail.node_ptr == current_head.node_ptr ) {
      // Case 1: Collision detected, the head crosses the tail (the queue
      // is already empty). Restore to the old tail and report pop
      // failure.
      m_tail = old_tail;
      return false;
    } else if ( new_tail.index == current_head.index &&
                new_tail.node_ptr == current_head.node_ptr ) {
      // Case 2: Try to pop the last task in the queue. We need to
      // increment the head to ensure no stealer will access that only
      // task concurrently.
      DequeHead new_head = current_head;
      new_head.tag++;
      asm volatile("": : :"memory");
      // Atomically update the head. If that task has already been
      // stolen. Restore the tail and report failure.
      m_mutex.lock();
      asm volatile("": : :"memory");
      if ( m_head == current_head ) {
        m_head = new_head;
        m_mutex.unlock();
        asm volatile("": : :"memory");
        __sync_fetch_and_sub( &m_task_count, 1 );
        return true;
      } else {
        m_tail = old_tail;
        m_mutex.unlock();
        asm volatile("": : :"memory");
        return false;
      }
    } else {
      // Pop successed.
      __sync_fetch_and_sub( &m_task_count, 1 );
      return true;
    }
  }

  //----------------------------------------------------------------------
  // TaskQueue::dequeue_head
  //----------------------------------------------------------------------
  // Dequeue a task from the head. This method is called by stealers.
  // If the task beging dequeued is a loop task, then we split the task
  // into two piece and only steal a half.

  template< typename ItemType >
  bool WSDeque< ItemType >::dequeue_head( ItemType& task )
  {
    // Check if the task queue is empty
    asm volatile("": : :"memory");
    if ( is_empty() ) {
      return false;
    }

    // read current head and tail
    DequeHead current_head = m_head;
    DequeHead new_head     = current_head;

    asm volatile("": : :"memory");
    // Read the task.
    task = current_head.node_ptr->task_array[current_head.index];

    // Generate the new head after stealing.
    asm volatile("": : :"memory");
    bool head_node_moved = false;
    if ( current_head.index < deque_node_size - 1 ) {
      new_head.index++;
    } else {
      //new_head.tag++;
      //new_head.node_ptr = current_head.node_ptr->next_ptr;
      //new_head.index = 0;
      //head_node_moved = true;
      return false;
      
    }

    // Try to update the head. If failed (maybe another stealer got that
    // task) simply return failure.
    // Also, deallocate the memory for the node no longer needed.
    asm volatile("": : :"memory");
    m_mutex.lock();
    asm volatile("": : :"memory");
    if ( m_head == current_head ) {
      //if ( head_node_moved ) {
      //  //delete current_head.node_ptr;
      //  node_counter--;
      //  new_head.node_ptr->prev_ptr = NULL;
      //}
      m_head = new_head;
      m_mutex.unlock();
      asm volatile("": : :"memory");
      __sync_fetch_and_sub( &m_task_count, 1 );
      return true;
    } else {
      m_mutex.unlock();
      asm volatile("": : :"memory");
      return false;
    }
  }

}
