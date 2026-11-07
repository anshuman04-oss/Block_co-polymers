import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
# import random
import math
import sys
from scipy.spatial import distance_matrix
import time
sys.setrecursionlimit(10**6)

class Graph:
	def __init__(self,V): 
		self.V = V 
		self.adj = [[] for i in range(V)] 

	def DFSUtil(self, temp, v, visited):
		visited[v] = True
		temp.append(v)

		for i in self.adj[v]: 
			if visited[i] == False:  
				temp = self.DFSUtil(temp, i, visited) 
		return temp

	def addEdge(self, v, w): 
		self.adj[v].append(w) 
		self.adj[w].append(v) 
		# print (w,v)

	def connectedComponents(self): 
		visited = [] 
		cc = [] 
		for i in range(self.V): 
			visited.append(False) 
			# print(visited)
		for v in range(self.V): 
			if visited[v] == False: 
				temp = [] 
				cc.append(self.DFSUtil(temp, v, visited)) 
		return cc 

def check_graph(lines, arr,crr):	
	g = Graph(len(lines))
	a=np.array([list(map(float,i.split(','))) for i in lines])
	y=distance_matrix(a,a,2)
	y=(9.5>=y)&(y>0)
	for i in range(len(lines)):
		for j in range(len(lines)):
			if(j>i):
				if(y[i][j]==True):
					g.addEdge(i,j) 	 			
	cc = g.connectedComponents() 
	for i in range(len(cc)):
		comp = cc[i]
		cors = ''
		for j in comp:
			if len(g.adj[j])<5 or (len(cc[i])/10)%2>0:
				cors = 'string'
				# arr[len(cc[i])]+=1
				break
			else:
				cors = 'ring'
				# crr[len(cc[i])]+=1
		print(len(cc[i]), cors,file=open("result.txt", "a"))
		if cors=='string':
			arr[len(cc[i])]+=1
		else:
			crr[len(cc[i])]+=1

if __name__=="__main__":
	fp = open('final-state.xyz','r')
	lines = fp.read().split('\n\n\n')
	fp.close()
	arr = [0 for j in range(1701)]
	crr = [0 for j in range(1701)]
	a=0
	for i in lines:
		if len(i)>2:
			a=a+1
			start = time.time()
			print("Following are connected components", a)
			print("Following are connected components", a,file=open("result.txt", "a"))
			check_graph(i.split('\n'),arr,crr)
			end=time.time()
			#print(end - start)
	print("overall Frequency",file=open("result.txt", "a"))	
	print("String",file=open("result.txt", "a"))	
	for i in range(1,1701):
		#print("overall Frequency")
		if arr[i]>0:
	 		print(i,':', arr[i],file=open("result.txt", "a"))
	print("Cycle",file=open("result.txt", "a")) 	
	for j in range(1,1701): 
		if crr[j]>0:	
	 		print(j,':', crr[j],file=open("result.txt", "a"))