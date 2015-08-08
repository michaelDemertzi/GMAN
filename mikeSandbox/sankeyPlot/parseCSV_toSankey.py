# -*- coding: utf-8 -*-
"""
Parse data csvs to Sankey

Created on Wed Aug 05 18:54:01 2015

@author: Michael
"""
#import
import csv
import re
import numpy as np

#set constants 
nL = 14 #number of legislators to display
nC = 14 #number of contributors

#create dictionary by state
nodes = {}
contrib = {}
legislator = {}

#read in CSV
with open('data/keystone.csv','rb') as f:
    reader = csv.reader(f)
    i = 0
    isHeader=True
    fail = 0 #failed accrues with invalid dollar contribution such as NAs
    suceed = 0
    
    for row in reader:
        #deal with header
        if isHeader:
            header = row
            isHeader = False
            continue

        try:        
            c = row[10]
            if len(c) == 0:
                c = row[8] #this addresses when no company name is given. personal name used instead
            l = row[0]
            if row[6][0] == '-': #negative number:
                d = -int(re.search('[0-9]+',row[6]).group(0))
            else:
                d = int(re.search('[0-9]+',row[6]).group(0))
            
            #create notes by aggregate by legislator and contributor
            if c not in nodes:
                nodes[c] = {} #create dict for legislators
            if l not in nodes[c]:
                nodes[c][l] = nodes[c].get(l,0) + d #tally donation for that legislator for that contributor
            
            #store totals
            contrib[c] = contrib.get(c,0) + d            
            legislator[l] = legislator.get(l,0) + d   
            
            suceed +=1
        except:
            fail += 1


            fail += 1


    
#Find largest contributors and legislators 
print 'LARGEST CONTRIBUTORS'
contribMaxKeys = sorted(contrib, key=contrib.get, reverse=True)[:nC]
moneyShown = 0
for key in contribMaxKeys:
    print key
    print contrib[key]
    moneyShown += contrib[key]
    print ''

moneyNotShown = sum(contrib.values()) - moneyShown

print '\nMONEY SHOWN'
print moneyShown
print 'MONEY NOT SHOWN'
print moneyNotShown

print '\nRICHEST LEGISLATORS'
legislatorMaxKeys = sorted(legislator, key=legislator.get, reverse=True)[:nC]
moneyShown = 0
for key in legislatorMaxKeys:
    print key
    print legislator[key]
    moneyShown += legislator[key]
    print ''

moneyNotShown = sum(legislator.values()) - moneyShown

print '\nMONEY SHOWN'
print moneyShown
print 'MONEY NOT SHOWN'
print moneyNotShown

print '/n AMOUNT OF DONORS'
print len(contrib.keys())
print '/n AMOUNT OF LEGISLATORS'
print len(legislator.keys())

#Writing to csv
other_00 = 0 #not top contributor or legislator
other_01 = {} #not top contributor, but goes to top legislator
other_10 = {} #top contributor, but not top legislator

with open('data/nodes.csv', 'wb') as f:
    writer = csv.writer(f)
    writer.writerow(['source','target','value'])
    for c in nodes: #for every contributor
        if c in contribMaxKeys:#if in the list of max contributors
            for l in nodes[c]: #for every legislator that this cont donated to
                if nodes[c][l] > 0: #has to be positive dollar value
                    if l in legislatorMaxKeys: #if we are in the max legislator range
                        writer.writerow([c,l,nodes[c][l]])
                    else: #not a top legislator
                        other_10[c] = other_10.get(c,0) + nodes[c][l] #aggregate by contributor                   
        else:#not a top contributor
            for l in nodes[c]:
                if nodes[c][l] > 0:
                    if l in legislatorMaxKeys:
                        other_01[l] = other_01.get(l,0) + nodes[c][l] #aggregate by legislator
                    else: #not a top legislator
                        other_00 += nodes[c][l]
    ###Encode 'other' categories
    #for c in other_10:
    #    writer.writerow([c,'Other Legislators',other_10[c]])
    #for l in other_01:
    #    writer.writerow(['Other Donors',l,other_01[l]])
    #writer.writerow(['Other Donors','Other Legislators',other_00])                
                
