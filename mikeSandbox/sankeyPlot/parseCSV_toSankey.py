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
nL = 20 #number of legislators to display
nC = 20 #number of contributors

#create dictionary by state
nodes = {}
nodes2 = {}
nodes3 = {}
contrib = {}
legislator = {}
support = {}
vote = {}
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
                #d = -int(re.search('[0-9]+',row[6]).group(0))
                continue
            else:
                d = int(re.search('[0-9]+',row[6]).group(0))
            
            s = row[13]
            if s.lower() == 'support':
                s = 'Donor Supports'
            elif s.lower() == 'oppose':
                s = 'Donor Opposes'
            elif s.lower() == 'split':
                s = 'Donor is Split'
            else:
                s = "Undisclosed"
            
            v = row[3]
            if v.lower() == 'yes':
                v = 'Yes vote on bill'
            elif v.lower() == 'no':
                v = 'No vote on bill'
            else:
                v = 'no vote'
                
            #create notes by aggregate by legislator and contributor
            if c not in nodes:
                nodes[c] = {} #create dict for legislators
            if l not in nodes[c]:
                nodes[c][l] = {} #create dict for support
            if s not in nodes[c][l]:
                nodes[c][l][s] = {} #crete for vote            
            nodes[c][l][s][v] = nodes[c][l][s].get(v,0) + d
            
            #store totals
            contrib[c] = contrib.get(c,0) + d            
            legislator[l] = legislator.get(l,0) + d   
            support[s] = support.get(s,0) + d
            vote[v] = vote.get(v,0) + d
            
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
    
    for c in nodes:
        if c in contribMaxKeys:
            for l in nodes[c]:
                if l in legislatorMaxKeys:
                    lTotal = 0
                    for s in nodes[c][l]:
                        sTotal = 0
                        for v in nodes[c][l][s]:
                            d = nodes[c][l][s][v]
                            lTotal+=d
                            sTotal+=d
                            
                            writer.writerow([s,v,d])
                        writer.writerow([l,s,sTotal])
                    writer.writerow([c,l,lTotal])
                '''
                else:
                    lTotal = 0
                    for s in nodes[c][l]:
                        sTotal = 0
                        for v in nodes[c][l][s]:
                            d = nodes[c][l][s][v]
                            lTotal+=d
                            sTotal+=d
                            
                            writer.writerow([s,v,d])
                        writer.writerow(['Other legislators',s,sTotal])
                    writer.writerow([c,l,lTotal])    
                '''
        '''
        else:
        '''
    
    '''    
    for c in nodes: #for every contributor
        if c in contribMaxKeys:#if in the list of max contributors
            for l in nodes[c]: #for every legislator that this cont donated to
                if nodes[c][l] > 0: #has to be positive dollar value
                    lTotal = 0
                    
                    if l in legislatorMaxKeys: #if we are in the max legislator range
                        writer.writerow([c,l,lTotal])                                         
                    else: #not a top legislator
                        other_10[c] = other_10.get(c,0) + nodes[c][l] #aggregate by contributor                   
        else:#not a top contributor
            for l in nodes[c]:
                if nodes[c][l] > 0:
                    if l in legislatorMaxKeys:
                        other_01[l] = other_01.get(l,0) + nodes[c][l] #aggregate by legislator
                    else: #not a top legislator
                        other_00 += nodes[c][l]
    
    for l in legislator:
        if l in legislatorMaxKeys:           

        else:
            writer.writerow([l,s,nodes2[l][s]])
    
    
    
    ###Encode 'other' categories
    for c in other_10:
        writer.writerow([c,'Other Legislators',other_10[c]])
    for l in other_01:
        writer.writerow(['Other Donors',l,other_01[l]])
    #writer.writerow(['Other Donors','Other Legislators',other_00])                
    '''            
