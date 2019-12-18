import angr
import sys

base_addr = lambda x: x + 0x400000

def main(argv):
  path_to_binary = argv[1]
  project = angr.Project(path_to_binary)
  initial_state = project.factory.entry_state()
  simulation = project.factory.simgr(initial_state)

  print_good_address = base_addr(0x0000072a)  # addr of correct path after strcmp inside maybe_good()
  will_not_succeed_address = base_addr(0x000006df) # addr of avoid_me()
  simulation.explore(find=print_good_address, avoid=will_not_succeed_address)

  if simulation.found:
    solution_state = simulation.found[0]
    print solution_state.posix.dumps(sys.stdin.fileno())
  else:
    raise Exception('Could not find the solution')

if __name__ == '__main__':
  main(sys.argv)
