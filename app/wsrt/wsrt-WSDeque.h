//========================================================================
// Work-stealing Runtime: Deque (Double-Ended Queue)
//========================================================================
// A task-queue is the data structure holds spawned but not yet be
// executed tasks. Each thread has one task-queue. Tasks are pushed to
// the queue at the tail. When the thread is avaliable, it will pop out a
// task from the tail to execute. When a thread runs out of tasks, it
// will randomly choose a victim to steal a task from it.  Tasks are
// stolen from the head of the task-queue.
//
// D. Hendler, Y. Lev, M. Moir, and N. Shavit, “A Dynamic-Sized
// Nonblocking Work Stealing Deque,” Menlo Park, CA 94025,
// SMLI TR-2005-144, Nov. 2005. for details.
//
// The task queue is a double-linked list, each node of the linked list
// contains an array. Once the node is full, new node will be allocated
// and linked to the current node.

// Each thread owns a task queue, only owner can update the queue from
// the tail (back). Task stealing always happens at the head of the
// queue. The queue is non-blocking. Push a task to the tail always
// returns immediately. Pop a task from the tail generally is also
// lock-free but if there is possible collision between the head and the
// tail, it will use atomic compare_and_swap to update the head in order
// to prevent race condition. Stealing from the head always uses atomic
// compare_and_swap and only one thieve succeeds.

#ifndef WSRT_WSDEQUE_H
#define WSRT_WSDEQUE_H

#include "common.h"

namespace wsrt {

  template < typename ItemType >
  class WSDeque {
  public:

    static const int deque_node_size = 300;

    struct DequeNode {
      ItemType    task_array[deque_node_size];
      DequeNode*  next_ptr = NULL;
      DequeNode*  prev_ptr = NULL;
    };

    // Structures for the head and the tail, which contains a pointer to
    // the node and the array index within that node. The head of the
    // queue contains a tag to prevent the ABA problem

    struct DequeHead {
      DequeNode* node_ptr;
      int        index;
      int        tag;

      bool operator==( const DequeHead& head1 ) const
      {
        return ( node_ptr == head1.node_ptr &&
                 index    == head1.index    &&
                 tag      == head1.tag );
      }
    };

    struct DequeTail {
      DequeNode* node_ptr;
      int        index;

      bool operator==( const DequeTail& tail1 ) const
      {
        return ( node_ptr == tail1.node_ptr &&
                 index    == tail1.index );
      }

    };

    WSDeque();

    // methods to access task queue

    bool enqueue_tail( const ItemType& task );
    bool dequeue_tail(       ItemType& task );
    bool dequeue_head(       ItemType& task );

    // utility functions

    int  get_ntasks();

    bool is_empty();

  private:

    DequeHead      m_head;
    DequeTail      m_tail;
    bthread_Mutex  m_mutex;
    int            m_task_count;
    DequeNode      nodes[1];
    int            node_counter = 0;

  };

}

//------------------------------------------------------------------------
// Include inline source files
//------------------------------------------------------------------------

#include "wsrt-WSDeque.inl"

#endif /* BTHREAD_TASKQUEUE_H */

