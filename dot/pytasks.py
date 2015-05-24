#!/usr/bin/python
import sys
import os
ff='/home/spospartan104/.todorepo/%s'
fdir='/home/spospartan104/.todorepo'
class TaskList(object):
  def __init__(self):
    self.tasks=list()
    if not(os.path.isdir(fdir)):
      os.mkdir(fdir)

  def loadTasks(self):
    if os.path.exists(ff%'cur.todo'):
      curtod=open(ff%'cur.todo','r')
      for line in curtod:
        if line and not(line.isspace()):
          print(line)
          task=line.split(' ',maxsplit=1)
          print(len(task))
          self.tasks.append(task[1])
      curtod.close()

  def addTask(self, task):
    self.tasks.append(task)

  def delTask(self, number):
    if number<=len(self.tasks):
      self.tasks.pop(number-1)

  def writeTasks(self):
    fle=open(ff%'cur.todo','w')
    for itemInd in range(len(self.tasks)):
      fle.write('%s. %s\n'%(itemInd+1,self.tasks[itemInd]))
    fle.close()

def main(argv=None):
  if argv is None:
    argv=sys.argv[1:]
  tm=TaskList()
  tm.loadTasks()
  if argv[0]=='a':
    tm.addTask(' '.join(argv[1:]))
  elif argv[0]=='d':
    tm.delTask(int(argv[1]))
  tm.writeTasks()

  

if __name__ == "__main__":
    sys.exit(main())





