import '../models/study_content.dart';

final List<Module> osModules = [
  // MODULE 2
  Module(
    id: 2,
    title: 'MODULE 2 — PROCESS + SCHEDULING + THREADS',
    topics: [
      Topic(
        id: '2.1',
        title:
            '2.1 — Concept of a Process, Process States, Process Description, PCB',
        content: '''
PROCESSES — Where Programs Come to Life!

This section covers the fundamental building blocks of operating systems:
• What processes are and how they differ from programs
• The lifecycle of a process through various states
• Process Control Block (PCB) structure
• Context switching mechanics
• Process vs Program vs Thread

Click each question below to reveal detailed answers with diagrams!
''',
        pyqs: [
          PYQ(
            question:
                'What is a process? Draw and Explain Process State Transition Diagram with six states.',
            type: 'theory',
            answer:
                '''A process is a program in execution. It's not just code sitting on disk — it's alive, dynamic, and doing work!

KEY COMPONENTS OF A PROCESS:
1. Program Code (Text Section) - Your actual instructions
2. Program Counter (PC) - Points to the next instruction to execute
3. CPU Registers - Temporary storage for current operations
4. Stack - Function calls and local variables
5. Data Section - Global variables
6. Heap - Dynamically allocated memory

PROCESS vs PROGRAM:
• Program = Passive entity (executable file on disk)
• Process = Active entity (program in execution)
• One program can create multiple processes

Example: Opening Chrome twice creates TWO processes from ONE program.

The Five-State Process Model shows how a process transitions through its lifecycle (see diagram below). The six-state model adds SUSPENDED states when processes are swapped to disk.''',
            hasDiagram: true,
          ),
          PYQ(
            question:
                'What is an Operating System? Explain its basic functions.',
            type: 'theory',
            answer:
                '''An Operating System is the middleman between you (the user) and the hardware. Without it, your computer is just expensive metal.

DEFINITION: Software that manages hardware resources and provides services to application programs.

BASIC FUNCTIONS:
1. PROCESS MANAGEMENT
   - Create, schedule, and terminate processes
   - Handle multitasking and context switching
   
2. MEMORY MANAGEMENT  
   - Allocate and deallocate memory
   - Virtual memory management
   - Protection between processes

3. FILE SYSTEM MANAGEMENT
   - Create, delete, read, write files
   - Organize data on storage devices
   - Access control and permissions

4. I/O DEVICE MANAGEMENT
   - Control and coordinate peripherals
   - Device drivers and buffering
   - Interrupt handling

5. SECURITY & PROTECTION
   - User authentication
   - Access control
   - Resource protection

6. NETWORKING
   - Network protocols
   - Communication between systems

Think of OS as a resource manager and traffic cop all in one!''',
            hasDiagram: false,
          ),
          PYQ(
            question: 'Explain the Five-state Process transition diagram.',
            type: 'theory',
            answer:
                '''The Five-State Model tracks a process's journey from birth to death. Every process MUST go through these states:

STATE DESCRIPTIONS:

1. NEW - Process is being created
   Fresh out of the oven! Not ready to run yet.

2. READY - Process is waiting for CPU
   Standing in line, eager and prepared to execute.

3. RUNNING - Process is executing on CPU
   The chosen one! Currently using the processor.

4. WAITING (BLOCKED) - Process is waiting for I/O or event
   Stuck waiting for something (disk read, user input, etc.)

5. TERMINATED (EXIT) - Process has finished execution
   Dead and gone. Time to clean up resources.

TRANSITIONS (The Journey):
• NEW → READY: Admit (OS loads process into memory)
• READY → RUNNING: Dispatch (Scheduler assigns CPU)
• RUNNING → READY: Interrupt (time slice expired, higher priority process arrives)
• RUNNING → WAITING: I/O Wait (process needs I/O operation)
• WAITING → READY: I/O Complete (I/O operation finished)
• RUNNING → TERMINATED: Exit (process completes or crashes)

IMPORTANT: A process CANNOT go directly from WAITING to RUNNING. It must pass through READY first!

See diagram below for visual representation.''',
            hasDiagram: true,
          ),
          PYQ(
            question:
                'What is the role of PCB? Explain the structure of PCB with its disadvantages.',
            type: 'theory',
            answer:
                '''The Process Control Block (PCB) is the OS's database entry for each process. Think of it as a process's ID card with all vital info!

ROLE OF PCB:
The PCB stores ALL information needed to manage a process. When the OS switches between processes (context switch), it saves/restores PCB data.

PCB STRUCTURE (What's Inside):

1. PROCESS ID (PID) - Unique identifier for the process

2. PROCESS STATE - Current state (NEW, READY, RUNNING, WAITING, TERMINATED)

3. PROGRAM COUNTER - Address of next instruction to execute

4. CPU REGISTERS - Contents of all registers (AX, BX, CX, DX, SP, BP, etc.)

5. CPU SCHEDULING INFO
   - Priority level
   - Scheduling queue pointers
   - Time slices

6. MEMORY MANAGEMENT INFO
   - Base and limit registers
   - Page tables
   - Segment tables

7. ACCOUNTING INFORMATION
   - CPU time used
   - Clock time elapsed
   - Time limits

8. I/O STATUS INFORMATION
   - List of open files
   - List of allocated devices
   - I/O requests

DISADVANTAGES OF PCB:

1. OVERHEAD - Context switching requires saving/loading entire PCB (expensive!)

2. MEMORY CONSUMPTION - Each process needs PCB space (scales with process count)

3. CONTEXT SWITCH TIME - More PCB data = longer switch time = performance hit

4. COMPLEXITY - Managing PCBs adds OS complexity

But hey, without PCB, multitasking wouldn't exist. Small price to pay!

See diagram below for PCB structure visualization.''',
            hasDiagram: true,
          ),
          PYQ(
            question: 'Differentiate between a Process and a Thread.',
            type: 'theory',
            answer:
                '''Processes and Threads are both units of execution, but threads are lightweight processes that share resources. Here's the breakdown:

PROCESS:
• Independent execution unit
• Has its own memory space (code, data, heap, stack)
• Heavyweight — expensive to create and switch
• Isolated from other processes
• Communication via IPC (Inter-Process Communication)
• One process crash doesn't affect others

THREAD:
• Lightweight execution unit WITHIN a process
• Shares code, data, and heap with other threads in same process
• Has its own stack and registers
• Cheap to create and switch
• Can directly access shared data
• One thread crash can crash entire process

ANALOGY:
Process = House with separate address, utilities, furniture
Thread = Roommates sharing the same house

WHY USE THREADS?
1. PARALLELISM - Utilize multiple CPU cores
2. RESPONSIVENESS - UI thread stays responsive while worker threads compute
3. RESOURCE SHARING - No need for complex IPC
4. ECONOMY - Faster creation and context switching

COMPARISON TABLE:

| Aspect | Process | Thread |
|--------|---------|--------|
| Weight | Heavy | Light |
| Creation Time | Slow | Fast |
| Context Switch | Expensive | Cheap |
| Memory | Separate | Shared |
| Communication | IPC needed | Direct |
| Isolation | High | Low |

Example: Chrome browser creates one process per tab (isolation), but each tab has multiple threads (for rendering, JavaScript, etc.)''',
            hasDiagram: false,
          ),
        ],
      ),
      Topic(
        id: '2.2',
        title: '2.2 — Uniprocessor Scheduling (Preemptive & Non-preemptive)',
        content: '''
CPU SCHEDULING — Who Gets the CPU Next?

The OS's way of deciding which process gets to use the CPU and when. Think of it as being the bouncer at an exclusive club, but for processes.

Topics covered:
• Scheduling criteria and goals
• Preemptive vs Non-preemptive algorithms
• FCFS, SJF, SRTF, Priority, Round Robin
• Gantt charts and performance calculations

Click each question for detailed roasts... I mean explanations!
''',
        pyqs: [
          PYQ(
            question:
                'Explain in brief the types of CPU schedulers with a diagram.',
            type: 'theory',
            answer: '''CPU Scheduling decides which process runs next when the CPU is free. It's literally the OS playing favorites with your programs.

THREE TYPES OF SCHEDULERS:

1. LONG-TERM SCHEDULER (Job Scheduler)
   • Selects which processes get admitted to ready queue
   • Controls degree of multiprogramming
   • Slow frequency (minutes)
   • Decides mix of I/O and CPU-bound processes
   • Think: Admissions officer at college

2. SHORT-TERM SCHEDULER (CPU Scheduler)
   • Selects which ready process gets CPU next
   • Very fast frequency (milliseconds)
   • Also called "dispatcher"
   • Most important for performance
   • Think: Professor calling on students

3. MEDIUM-TERM SCHEDULER
   • Swapping - removes processes from memory
   • Controls degree of multiprogramming
   • Brings processes back later
   • Helps manage memory
   • Think: Bouncer kicking people out temporarily

THE FLOW:
New Process → Long-term → Ready Queue → Short-term → Running
                                           ↕
                                    Medium-term
                                           ↕
                                    Swapped Out (Disk)

Fun fact: Most modern systems don't use long-term schedulers anymore. They YOLO everything into memory and hope for the best.''',
            hasDiagram: false,
          ),
          PYQ(
            question: 'Discuss various CPU scheduling criteria.',
            type: 'theory',
            answer: '''CPU Scheduling Criteria are the metrics we use to judge if a scheduling algorithm sucks or not. Spoiler: They all suck in different ways!

CRITERIA (aka What We're Trying to Optimize):

1. CPU UTILIZATION (↑ Better)
   • Keep CPU busy as much as possible
   • Target: 40% (lightly loaded) to 90% (heavily loaded)
   • Why: Idle CPU = Wasted money
   • Reality: Your gaming laptop at 2% watching Netflix

2. THROUGHPUT (↑ Better)
   • Number of processes completed per time unit
   • More processes done = Better
   • Measured in processes/hour or processes/second
   • Why: Want to complete more work
   • Reality: Your professor grading 5 papers per week

3. TURNAROUND TIME (↓ Better)
   • Time from submission to completion
   • Includes waiting + execution time
   • Formula: Completion Time - Arrival Time
   • Why: Users hate waiting
   • Reality: Your code taking forever to compile

4. WAITING TIME (↓ Better)
   • Time spent in ready queue
   • NOT execution time, just sitting around
   • Why: Pure waste - process isn't making progress
   • Reality: You waiting for your turn at the printer

5. RESPONSE TIME (↓ Better)
   • Time from submission to FIRST response
   • Critical for interactive systems
   • Different from turnaround time
   • Why: User perception of speed
   • Reality: That spinning wheel on your iPhone

THE TRADE-OFF PROBLEM:
You can't optimize everything! It's like trying to have:
• Low prices
• High quality
• Fast delivery
Pick two, suffer with the third.

Example: FCFS has good throughput but terrible response time. SJF has minimum waiting time but causes starvation. Round Robin has great response time but high context switch overhead.

The OS is basically trying to balance being fair (everyone gets a turn) with being efficient (fast processes first). It's harder than it sounds!''',
            hasDiagram: false,
          ),
          PYQ(question: 'Explain CPU Scheduling Criteria.', type: 'theory',
            answer: '''(Same as previous question - this is a duplicate PYQ asking the same thing)

CPU Scheduling Criteria = The report card for scheduling algorithms.

THE BIG FIVE:

1. CPU UTILIZATION - How busy is the CPU?
   Goal: 40-90% (Higher = Better)
   
2. THROUGHPUT - How many processes complete?
   Goal: Maximize (More = Better)
   
3. TURNAROUND TIME - Total time to finish
   Goal: Minimize (Lower = Better)
   Formula: Completion Time - Arrival Time
   
4. WAITING TIME - Time wasted in queue
   Goal: Minimize (Lower = Better)
   Formula: Turnaround Time - Burst Time
   
5. RESPONSE TIME - Time to first response
   Goal: Minimize (Lower = Better)
   Formula: First Run Time - Arrival Time

WHY IT MATTERS:
• Users care about response time (feels fast)
• System admins care about throughput (more work done)
• Everyone hates waiting time (pure waste)
• CPU utilization = money (idle hardware = wasted cash)

Remember: You CANNOT optimize all five simultaneously. Every algorithm makes trade-offs. Choose your poison!''',
            hasDiagram: false,
          ),
          PYQ(
            question:
                'Differentiate between Preemptive and Non-preemptive scheduling algorithms.',
            type: 'theory',
            answer: '''Preemptive vs Non-Preemptive is basically asking: Can you interrupt a running process or nah?

NON-PREEMPTIVE SCHEDULING:
• Process keeps CPU until it finishes or blocks
• No interruptions, no take-backs
• Simple to implement
• Lower overhead (fewer context switches)
• Examples: FCFS, SJF (non-preemptive)

Think: Letting someone finish their entire presentation even though everyone's falling asleep.

PREEMPTIVE SCHEDULING:
• OS can yank CPU away from running process
• Allows interruption for higher priority/shorter jobs
• More complex implementation
• Higher overhead (context switching)
• Examples: SRTF, Round Robin, Priority (preemptive)

Think: Teacher stopping a student mid-sentence because someone else raised their hand.

KEY DIFFERENCES:

| Aspect | Non-Preemptive | Preemptive |
|--------|----------------|------------|
| Interruption | NO | YES |
| Context Switches | Fewer | More |
| Implementation | Simple | Complex |
| Response Time | Poor | Better |
| Starvation Risk | Higher | Lower |
| Overhead | Low | High |
| Fairness | Meh | Better |

WHEN TO USE WHAT:

Non-Preemptive:
✓ Batch systems (who cares about response time?)
✓ Simple embedded systems
✓ When context switching is expensive

Preemptive:
✓ Interactive systems (users hate waiting)
✓ Real-time systems (deadlines matter!)
✓ Time-sharing systems (everyone gets a turn)

The Verdict: Preemptive is usually better for modern systems unless you're running on a potato or don't care about responsiveness.''',
            hasDiagram: true,
          ),
          PYQ(
            question: 'Explain Round Robin Algorithm with a suitable example.',
            type: 'theory',
            answer: '''Round Robin (RR) is the "everyone gets a turn" algorithm. It's preemptive FCFS with a time limit per turn.

HOW IT WORKS:

1. Each process gets a fixed time slice (quantum)
2. If process finishes before quantum expires → Move to next
3. If quantum expires → Process goes to back of queue
4. CPU moves to next process in ready queue
5. Repeat forever (or until all processes done)

EXAMPLE: Time Quantum = 4ms

Processes:
P1: Burst Time = 24ms
P2: Burst Time = 3ms  
P3: Burst Time = 3ms

EXECUTION TIMELINE:
Time 0-4:   P1 runs (used 4/24ms, goes to back of queue)
Time 4-7:   P2 runs (used 3/3ms, DONE!)
Time 7-10:  P3 runs (used 3/3ms, DONE!)
Time 10-14: P1 runs (used 8/24ms, back to queue)
Time 14-18: P1 runs (used 12/24ms, back to queue)
Time 18-22: P1 runs (used 16/24ms, back to queue)
Time 22-26: P1 runs (used 20/24ms, back to queue)
Time 26-30: P1 runs (used 24/24ms, DONE!)

Waiting Times:
P1: (30-24) = 6ms waited
P2: (4-0) = 4ms waited
P3: (7-0) = 7ms waited
Average Waiting Time = (6+4+7)/3 = 5.67ms

CHOOSING TIME QUANTUM:
• Too small → Too many context switches (overhead hell)
• Too large → Becomes FCFS (defeats the purpose)
• Sweet spot: 10-100ms usually works

PROS:
✓ Fair - everyone gets equal CPU time
✓ Good response time
✓ No starvation
✓ Simple to implement

CONS:
✗ Average turnaround time often higher than SJF
✗ Performance depends heavily on quantum size
✗ Context switching overhead

Real World: Used in time-sharing systems where responsiveness matters more than efficiency. Your OS probably uses a variation of this!''',
            hasDiagram: true,
          ),
          PYQ(
            question:
                'Draw Gantt chart for FCFS, SJF (Preemptive) and Round Robin (Quantum=2). Also calculate average waiting time and turnaround time.',
            type: 'numerical',
            answer: '''This is a numerical problem where you'd be given process arrival times and burst times. Here's the approach:

GIVEN DATA (Example):
Process | Arrival | Burst
P1      | 0       | 4
P2      | 1       | 3
P3      | 2       | 1

FCFS (First Come First Serve):
Run in arrival order: P1 → P2 → P3
Gantt Chart: |P1(0-4)|P2(4-7)|P3(7-8)|

Calculations:
P1: TAT = 4-0 = 4, WT = 0
P2: TAT = 7-1 = 6, WT = 3
P3: TAT = 8-2 = 6, WT = 5
Avg TAT = 5.33, Avg WT = 2.67

SRTF (Preemptive SJF):
Always run shortest remaining time
Gantt Chart: |P1(0-1)|P2(1-2)|P3(2-3)|P2(3-5)|P1(5-8)|

Calculations:
P1: TAT = 8-0 = 8, WT = 4
P2: TAT = 5-1 = 4, WT = 1  
P3: TAT = 3-2 = 1, WT = 0
Avg TAT = 4.33, Avg WT = 1.67

ROUND ROBIN (Quantum = 2):
Everyone gets 2ms turns
Gantt Chart: |P1(0-2)|P2(2-4)|P3(4-5)|P1(5-7)|P2(7-8)|

Calculations:
P1: TAT = 7-0 = 7, WT = 3
P2: TAT = 8-1 = 7, WT = 4
P3: TAT = 5-2 = 3, WT = 2
Avg TAT = 5.67, Avg WT = 3

FORMULAS TO REMEMBER:
• Turnaround Time = Completion Time - Arrival Time
• Waiting Time = Turnaround Time - Burst Time
• Average = Sum / Number of Processes

In exams, you'll get specific numbers. Just follow the algorithm rules, draw the Gantt chart carefully, and calculate using the formulas. Easy marks if you don't mess up the arithmetic!''',
            hasDiagram: true,
          ),
          PYQ(
            question:
                'Draw Gantt chart for FCFS and SJF scheduling for given processes.',
            type: 'numerical',
            answer: '''Another Gantt chart question! The approach is the same as above.

FCFS ALGORITHM:
1. Sort processes by arrival time
2. Run them in that order
3. Each process completes before next starts

SJF (Non-preemptive) ALGORITHM:
1. Pick process with shortest burst time that has arrived
2. Run it to completion
3. Repeat for next shortest available process

EXAMPLE:
Process | Arrival | Burst
P1      | 0       | 7
P2      | 2       | 4
P3      | 4       | 1
P4      | 5       | 4

FCFS:
Order: P1 → P2 → P3 → P4
|P1(0-7)|P2(7-11)|P3(11-12)|P4(12-16)|

P1: TAT=7, WT=0
P2: TAT=9, WT=5
P3: TAT=8, WT=7
P4: TAT=11, WT=7
Avg TAT=8.75, Avg WT=4.75

SJF:
At time 0: Only P1 available → Run P1
At time 7: P2(4), P3(1), P4(4) available → Run P3 (shortest)
At time 8: P2(4), P4(4) available → Run P2 (arrived first)
At time 12: Only P4 left → Run P4

Order: P1 → P3 → P2 → P4
|P1(0-7)|P3(7-8)|P2(8-12)|P4(12-16)|

P1: TAT=7, WT=0
P2: TAT=10, WT=6
P3: TAT=4, WT=3
P4: TAT=11, WT=7
Avg TAT=8, Avg WT=4

PRO TIPS:
• Make a timeline showing when each process arrives
• For SJF, check which processes have arrived before choosing
• Double-check your arithmetic (easiest way to lose marks)
• Label your Gantt chart axes clearly

In exams, they'll give you the numbers. Just execute the algorithm step by step and you'll be fine!''',
            hasDiagram: true,
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
            question:
                'Differentiate between User Level Thread and Kernel Level Thread.',
            type: 'theory',
          ),
          PYQ(question: 'Concept of Multithreading.', type: 'theory'),
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
            question:
                'Discuss Producer and Consumer problem with solution using Semaphore.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain the Critical Section Problem.',
            type: 'theory',
          ),
          PYQ(question: 'Explain Principles of Concurrency.', type: 'theory'),
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
            question:
                'Explain the term "Busy Waiting". Give solution to this problem using Semaphore.',
            type: 'theory',
          ),
          PYQ(
            question: 'Explain Producer consumer problem using Semaphores.',
            type: 'theory',
          ),
          PYQ(
            question:
                'Explain Dining Philosophers Problem with solution using Semaphore.',
            type: 'theory',
          ),
          PYQ(
            question:
                'Explain Hardware solution proposed to solve the critical section problem.',
            type: 'theory',
          ),
        ],
      ),
      Topic(
        id: '3.3',
        title:
            '3.3 — Deadlock: Conditions, RAG, Prevention, Avoidance, Detection, Recovery',
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
            question:
                'What is a Deadlock? Explain the necessary conditions for a deadlock to take place.',
            type: 'theory',
          ),
          PYQ(
            question:
                'Explain how Resource Allocation Graph (RAG) and Wait For Graph (WFG) are used to determine presence of a deadlock.',
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
            question:
                'Given the following snapshot, determine Need Matrix and Safe Sequence. Check if system is in safe state.',
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
        title:
            '4.1 — Memory Management Requirements, Partitioning, Allocation, Paging, Segmentation, TLB',
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
            question:
                'Explain Memory Allocation Strategies with suitable examples.',
            type: 'theory',
          ),
          PYQ(
            question:
                'Given five memory partitions, allocate using first-fit, best-fit and worst-fit.',
            type: 'numerical',
          ),
          PYQ(question: 'Explain MFT with an example.', type: 'theory'),
          PYQ(
            question: 'What is External Fragmentation? Explain with example.',
            type: 'theory',
          ),
          PYQ(
            question: 'How to solve the fragmentation problem using Paging?',
            type: 'theory',
          ),
          PYQ(question: 'TLB.', type: 'theory'),
        ],
      ),
      Topic(
        id: '4.2',
        title:
            '4.2 — Virtual Memory, Demand Paging, Page Replacement, Thrashing',
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
            question:
                'Explain Page Replacement Strategies with suitable examples.',
            type: 'theory',
          ),
          PYQ(
            question:
                'Calculate page faults for FIFO, Optimal and LRU for the following reference string.',
            type: 'numerical',
          ),
          PYQ(question: 'Thrashing.', type: 'theory'),
        ],
      ),
    ],
  ),
];
