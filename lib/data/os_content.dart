import '../models/study_content.dart';

final List<Module> osModules = [
  // MODULE 2
  Module(
    id: 2,
    title: 'MODULE 2 — PROCESS + SCHEDULING + THREADS',
    topics: [
      Topic(
        id: '2.1',
        title: '2.1 — Concept of a Process, Process States, Process Description, PCB',
        content: '''
**Process Basics:**
A process is a program in execution. It includes program code, current activity (program counter), stack, data section, and heap.

**Process States:**
- NEW: Process being created
- READY: Waiting to be assigned to processor
- RUNNING: Instructions being executed
- WAITING: Waiting for I/O or event
- TERMINATED: Process finished execution

**Process Control Block (PCB):**
Data structure containing:
- Process state
- Program counter
- CPU registers
- CPU scheduling info
- Memory management info
- Accounting info
- I/O status info

**PCB Disadvantages:**
- Overhead in context switching
- Large memory requirement
- Complex management
''',
        pyqs: [
          PYQ(
            question: 'What is a process? Draw and Explain Process State Transition Diagram with six states.',
            type: 'theory',
          ),
          PYQ(
            question: 'What is an Operating System? Explain its basic functions.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain the Five-state Process transition diagram.',
            type: 'theory',
          ),
          PYQ(
            question: 'What is the role of PCB? Explain the structure of PCB with its disadvantages.',
            type: 'theory',
          ),
          PYQ(
            question: 'Differentiate between a Process and a Thread.',
            type: 'theory',
          ),
        ],
      ),
      Topic(
        id: '2.2',
        title: '2.2 — Uniprocessor Scheduling (Preemptive & Non-preemptive)',
        content: '''
**CPU Scheduling Algorithms:**

**1. FCFS (First Come First Serve):**
- Non-preemptive
- Simple queue implementation
- Average waiting time often long
- Convoy effect problem

**2. SJF (Shortest Job First):**
- Non-preemptive version
- Minimum average waiting time
- Difficult to predict burst time
- Starvation possible

**3. SRTN (Shortest Remaining Time Next):**
- Preemptive SJF
- Optimal preemptive algorithm
- More context switches

**4. Priority Scheduling:**
- Can be preemptive or non-preemptive
- Starvation problem (solved by aging)
- Higher priority = lower number

**5. Round Robin (RR):**
- Preemptive FCFS
- Time quantum/slice
- Fair allocation
- Performance depends on quantum size

**Scheduling Criteria:**
- CPU Utilization
- Throughput
- Turnaround Time
- Waiting Time
- Response Time
''',
        pyqs: [
          PYQ(
            question: 'Explain in brief the types of CPU schedulers with a diagram.',
            type: 'theory',
          ),
          PYQ(
            question: 'Discuss various CPU scheduling criteria.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain CPU Scheduling Criteria.',
            type: 'theory',
          ),
          PYQ(
            question: 'Differentiate between Preemptive and Non-preemptive scheduling algorithms.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain Round Robin Algorithm with a suitable example.',
            type: 'theory',
          ),
          PYQ(
            question: 'Draw Gantt chart for FCFS, SJF (Preemptive) and Round Robin (Quantum=2). Also calculate average waiting time and turnaround time.',
            type: 'numerical',
          ),
          PYQ(
            question: 'Draw Gantt chart for FCFS and SJF scheduling for given processes.',
            type: 'numerical',
          ),
        ],
      ),
      Topic(
        id: '2.3',
        title: '2.3 — Threads: Definition, Types, Concept of Multithreading',
        content: '''
**Thread:**
A thread is a lightweight process, the basic unit of CPU utilization. It shares code, data, and OS resources with other threads of the same process.

**Benefits of Multithreading:**
- Responsiveness
- Resource sharing
- Economy
- Scalability

**Types of Threads:**

**1. User-Level Threads (ULT):**
- Managed by thread library
- Fast context switch
- OS treats it as single-threaded
- Blocking system call blocks entire process

**2. Kernel-Level Threads (KLT):**
- Managed by OS kernel
- True parallelism on multiprocessor
- Slower context switch
- Each thread can be scheduled independently

**Multithreading Models:**
- Many-to-One
- One-to-One
- Many-to-Many
''',
        pyqs: [
          PYQ(
            question: 'Define Thread. Mention benefits of Multithreading.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain different types of thread in Operating System.',
            type: 'theory',
          ),
          PYQ(
            question: 'Differentiate between User Level Thread and Kernel Level Thread.',
            type: 'theory',
          ),
          PYQ(
            question: 'Concept of Multithreading.',
            type: 'theory',
          ),
        ],
      ),
    ],
  ),

  // MODULE 3
  Module(
    id: 3,
    title: 'MODULE 3 — PROCESS SYNCHRONIZATION & DEADLOCKS',
    topics: [
      Topic(
        id: '3.1',
        title: '3.1 — Concurrency, IPC, Process Synchronization',
        content: '''
**Concurrency:**
Multiple processes executing simultaneously, sharing resources and communicating.

**Principles of Concurrency:**
- Process synchronization needed
- Race condition must be avoided
- Mutual exclusion required
- Deadlock and starvation prevention

**Critical Section Problem:**
Section of code where shared resources are accessed. Requirements:
1. Mutual Exclusion
2. Progress
3. Bounded Waiting

**Producer-Consumer Problem:**
Classic synchronization problem with bounded buffer.

**Solution using Semaphores:**
```
Semaphore mutex = 1;
Semaphore empty = n;
Semaphore full = 0;

Producer:
  wait(empty);
  wait(mutex);
  // produce item
  signal(mutex);
  signal(full);

Consumer:
  wait(full);
  wait(mutex);
  // consume item
  signal(mutex);
  signal(empty);
```
''',
        pyqs: [
          PYQ(
            question: 'Discuss Producer and Consumer problem with solution using Semaphore.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain the Critical Section Problem.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain Principles of Concurrency.',
            type: 'theory',
          ),
        ],
      ),
      Topic(
        id: '3.2',
        title: '3.2 — Mutual Exclusion, Requirements, TSL, Semaphores',
        content: '''
**Mutual Exclusion:**
Ensures only one process executes in critical section at a time.

**Requirements:**
1. Only one process in CS
2. No assumption about speed/processors
3. Process outside CS cannot block others
4. No indefinite postponement

**Hardware Solutions:**

**Test-and-Set Lock (TSL):**
Atomic instruction that tests and modifies memory location.
```
while (TestAndSet(&lock));
  // critical section
lock = false;
```

**Semaphores:**
Integer variable with two atomic operations:
- wait(S) / P(S) / down(S)
- signal(S) / V(S) / up(S)

**Types:**
- Binary Semaphore (0 or 1)
- Counting Semaphore (0 to n)

**Busy Waiting Problem:**
Process continuously checks condition (spinlock).
Solution: Block and wakeup mechanism using semaphores.

**Dining Philosophers Problem:**
5 philosophers, 5 chopsticks, need 2 to eat.
Solution using semaphores prevents deadlock.
''',
        pyqs: [
          PYQ(
            question: 'Explain the term "Busy Waiting". Give solution to this problem using Semaphore.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain Producer consumer problem using Semaphores.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain Dining Philosophers Problem with solution using Semaphore.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain Hardware solution proposed to solve the critical section problem.',
            type: 'theory',
          ),
        ],
      ),
      Topic(
        id: '3.3',
        title: '3.3 — Deadlock: Conditions, RAG, Prevention, Avoidance, Detection, Recovery',
        content: '''
**Deadlock:**
Set of processes blocked, each holding resources and waiting for resources held by others.

**Necessary Conditions:**
1. Mutual Exclusion
2. Hold and Wait
3. No Preemption
4. Circular Wait

All four must hold simultaneously.

**Resource Allocation Graph (RAG):**
- Vertices: Processes (circles) and Resources (rectangles)
- Edges: Request (P→R) and Assignment (R→P)
- Cycle in graph may indicate deadlock

**Wait-For Graph (WFG):**
Simplified RAG for single-instance resources.
Cycle = Deadlock.

**Deadlock Prevention:**
Break one of four conditions:
- Allow preemption
- Request all resources at once
- Order resources numerically

**Deadlock Avoidance (Banker's Algorithm):**
- Safe state vs Unsafe state
- Check before allocation
- Need = Max - Allocation
- Available resources tracking

**Deadlock Detection:**
- Invoke detection algorithm
- Check for cycles
- Recovery if found

**Recovery:**
- Process termination (all or one by one)
- Resource preemption
- Rollback
''',
        pyqs: [
          PYQ(
            question: 'What is a Deadlock? Explain the necessary conditions for a deadlock to take place.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain how Resource Allocation Graph (RAG) and Wait For Graph (WFG) are used to determine presence of a deadlock.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain Deadlock Avoidance algorithms with example.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain Deadlock Prevention techniques.',
            type: 'theory',
          ),
          PYQ(
            question: 'Given the following snapshot, determine Need Matrix and Safe Sequence. Check if system is in safe state.',
            type: 'numerical',
          ),
          PYQ(
            question: 'Explain the Dining Philosophers Problem.',
            type: 'theory',
          ),
        ],
      ),
    ],
  ),

  // MODULE 4
  Module(
    id: 4,
    title: 'MODULE 4 — MEMORY MANAGEMENT',
    topics: [
      Topic(
        id: '4.1',
        title: '4.1 — Memory Management Requirements, Partitioning, Allocation, Paging, Segmentation, TLB',
        content: '''
**Memory Management Requirements:**
1. Relocation
2. Protection
3. Sharing
4. Logical Organization
5. Physical Organization

**Memory Partitioning:**

**Fixed Partitioning (MFT):**
- Memory divided into fixed-size partitions
- Internal fragmentation
- Simple implementation
- Limit on process size

**Dynamic Partitioning (MVT):**
- Variable-size partitions
- External fragmentation
- Compaction needed
- Flexible

**Memory Allocation Strategies:**

**1. First Fit:**
- Allocate first hole big enough
- Fast
- May leave small unusable holes at beginning

**2. Best Fit:**
- Allocate smallest hole big enough
- Slowest
- Produces smallest leftover holes
- Worst fragmentation

**3. Worst Fit:**
- Allocate largest hole
- Produces largest leftover holes
- Better for large requests

**Fragmentation:**
- External: Free memory scattered
- Internal: Allocated memory larger than needed

**Paging:**
- Physical memory: frames (fixed size)
- Logical memory: pages (same size)
- Page table maps pages to frames
- No external fragmentation
- Internal fragmentation (last page)

**Page Table Entry contains:**
- Frame number
- Valid/invalid bit
- Protection bits
- Reference bit
- Modified (dirty) bit

**Segmentation:**
- Logical view: segments (code, data, stack)
- Variable size
- Segment table (base, limit)
- External fragmentation possible
- Better protection and sharing

**Translation Lookaside Buffer (TLB):**
- Cache for page table entries
- Fast address translation
- Hit ratio critical for performance
- Associative memory
''',
        pyqs: [
          PYQ(
            question: 'Write in detail about Memory Management Requirements.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain concept of Paging with an example.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain Segmentation with an example.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain Memory Allocation Strategies with suitable examples.',
            type: 'theory',
          ),
          PYQ(
            question: 'Given five memory partitions, allocate using first-fit, best-fit and worst-fit.',
            type: 'numerical',
          ),
          PYQ(
            question: 'Explain MFT with an example.',
            type: 'theory',
          ),
          PYQ(
            question: 'What is External Fragmentation? Explain with example.',
            type: 'theory',
          ),
          PYQ(
            question: 'How to solve the fragmentation problem using Paging?',
            type: 'theory',
          ),
          PYQ(
            question: 'TLB.',
            type: 'theory',
          ),
        ],
      ),
      Topic(
        id: '4.2',
        title: '4.2 — Virtual Memory, Demand Paging, Page Replacement, Thrashing',
        content: '''
**Virtual Memory:**
Separation of logical and physical memory.
- Only part of program in memory
- Larger programs than physical memory
- More processes in memory
- Less I/O for load/swap

**Demand Paging:**
- Load pages only when needed
- Lazy swapper (pager)
- Valid/invalid bit in page table
- Page fault when invalid page accessed

**Page Fault Handling:**
1. Check internal table
2. Get empty frame
3. Read page from disk to frame
4. Update page table
5. Restart instruction

**Page Replacement Algorithms:**

**1. FIFO (First In First Out):**
- Simple queue
- Belady's Anomaly possible
- Not optimal
- Easy to implement

**2. Optimal (OPT):**
- Replace page not used for longest time
- Theoretical best
- Cannot implement (need future knowledge)
- Used for comparison

**3. LRU (Least Recently Used):**
- Replace page not used for longest time in past
- Better than FIFO
- Requires hardware support
- Stack or counter implementation

**Implementation Methods:**
- Counter: Timestamp for each reference
- Stack: Doubly linked list

**Thrashing:**
Process spending more time paging than executing.

**Causes:**
- High degree of multiprogramming
- Insufficient frames
- Poor page replacement

**Prevention:**
- Working set model
- Page fault frequency control
- Local replacement policy
- Adequate frame allocation
''',
        pyqs: [
          PYQ(
            question: 'Explain Page Replacement Strategies with suitable examples.',
            type: 'theory',
          ),
          PYQ(
            question: 'Calculate page faults for FIFO, Optimal and LRU for the following reference string.',
            type: 'numerical',
          ),
          PYQ(
            question: 'Thrashing.',
            type: 'theory',
          ),
        ],
      ),
    ],
  ),
];
