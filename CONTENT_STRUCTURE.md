# OS Course Content Structure

## Module 2: Process + Scheduling + Threads

### 2.1 - Concept of a Process, Process States, Process Description, PCB
**Theory Covered:**
- Process definition and components
- Process states (NEW, READY, RUNNING, WAITING, TERMINATED)
- Process Control Block (PCB) structure
- Process vs Thread differentiation

**PYQs (5):**
1. What is a process? Draw and Explain Process State Transition Diagram with six states.
2. What is an Operating System? Explain its basic functions.
3. Explain the Five-state Process transition diagram.
4. What is the role of PCB? Explain the structure of PCB with its disadvantages.
5. Differentiate between a Process and a Thread.

---

### 2.2 - Uniprocessor Scheduling
**Theory Covered:**
- FCFS (First Come First Serve)
- SJF (Shortest Job First)
- SRTN (Shortest Remaining Time Next)
- Priority Scheduling
- Round Robin (RR)
- Scheduling criteria (CPU utilization, throughput, turnaround time, waiting time, response time)
- Preemptive vs Non-preemptive

**PYQs (7):**
1. Explain in brief the types of CPU schedulers with a diagram.
2. Discuss various CPU scheduling criteria.
3. Explain CPU Scheduling Criteria.
4. Differentiate between Preemptive and Non-preemptive scheduling algorithms.
5. Explain Round Robin Algorithm with a suitable example.
6. Draw Gantt chart for FCFS, SJF (Preemptive) and Round Robin (Quantum=2). Calculate average waiting time and turnaround time.
7. Draw Gantt chart for FCFS and SJF scheduling for given processes.

---

### 2.3 - Threads: Definition, Types, Concept of Multithreading
**Theory Covered:**
- Thread definition
- Benefits of multithreading
- User-Level Threads (ULT)
- Kernel-Level Threads (KLT)
- Multithreading models

**PYQs (4):**
1. Define Thread. Mention benefits of Multithreading.
2. Explain different types of thread in Operating System.
3. Differentiate between User Level Thread and Kernel Level Thread.
4. Concept of Multithreading.

---

## Module 3: Process Synchronization & Deadlocks

### 3.1 - Concurrency, IPC, Process Synchronization
**Theory Covered:**
- Concurrency principles
- Critical Section Problem
- Requirements (Mutual Exclusion, Progress, Bounded Waiting)
- Producer-Consumer problem with semaphore solution

**PYQs (3):**
1. Discuss Producer and Consumer problem with solution using Semaphore.
2. Explain the Critical Section Problem.
3. Explain Principles of Concurrency.

---

### 3.2 - Mutual Exclusion, Requirements, TSL, Semaphores
**Theory Covered:**
- Mutual Exclusion requirements
- Test-and-Set Lock (TSL) hardware solution
- Semaphores (Binary and Counting)
- Busy Waiting problem and solution
- Dining Philosophers Problem

**PYQs (4):**
1. Explain the term "Busy Waiting". Give solution to this problem using Semaphore.
2. Explain Producer consumer problem using Semaphores.
3. Explain Dining Philosophers Problem with solution using Semaphore.
4. Explain Hardware solution proposed to solve the critical section problem.

---

### 3.3 - Deadlock: Conditions, RAG, Prevention, Avoidance, Detection, Recovery
**Theory Covered:**
- Deadlock definition
- Four necessary conditions
- Resource Allocation Graph (RAG)
- Wait-For Graph (WFG)
- Deadlock prevention techniques
- Banker's Algorithm (avoidance)
- Detection and recovery methods

**PYQs (6):**
1. What is a Deadlock? Explain the necessary conditions for a deadlock to take place.
2. Explain how Resource Allocation Graph (RAG) and Wait For Graph (WFG) are used to determine presence of a deadlock.
3. Explain Deadlock Avoidance algorithms with example.
4. Explain Deadlock Prevention techniques.
5. Given the following snapshot, determine Need Matrix and Safe Sequence. Check if system is in safe state.
6. Explain the Dining Philosophers Problem.

---

## Module 4: Memory Management

### 4.1 - Memory Management Requirements, Partitioning, Allocation, Paging, Segmentation, TLB
**Theory Covered:**
- Memory management requirements (5 principles)
- Fixed Partitioning (MFT)
- Dynamic Partitioning (MVT)
- Allocation strategies (First Fit, Best Fit, Worst Fit)
- Fragmentation (Internal and External)
- Paging concept
- Segmentation
- Translation Lookaside Buffer (TLB)

**PYQs (9):**
1. Write in detail about Memory Management Requirements.
2. Explain concept of Paging with an example.
3. Explain Segmentation with an example.
4. Explain Memory Allocation Strategies with suitable examples.
5. Given five memory partitions, allocate using first-fit, best-fit and worst-fit.
6. Explain MFT with an example.
7. What is External Fragmentation? Explain with example.
8. How to solve the fragmentation problem using Paging?
9. TLB.

---

### 4.2 - Virtual Memory, Demand Paging, Page Replacement, Thrashing
**Theory Covered:**
- Virtual memory concept
- Demand paging
- Page fault handling
- FIFO page replacement
- Optimal page replacement
- LRU (Least Recently Used)
- Belady's Anomaly
- Thrashing causes and prevention

**PYQs (3):**
1. Explain Page Replacement Strategies with suitable examples.
2. Calculate page faults for FIFO, Optimal and LRU for the following reference string.
3. Thrashing.

---

## Summary Statistics

**Total Coverage:**
- **Modules**: 3 (Module 2, 3, 4)
- **Topics**: 8
- **Total PYQs**: 41
  - Theory Questions: 36
  - Numerical Questions: 5

**Question Types:**
- Theory questions cover concepts, explanations, comparisons
- Numerical questions include Gantt charts, scheduling calculations, page faults, Banker's algorithm

**Study Time Estimation:**
- Each topic: 30-60 minutes
- Total course: 4-8 hours
- Practice numericals: Additional 2-4 hours
