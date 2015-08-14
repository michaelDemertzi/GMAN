# -*- coding: utf-8 -*-
"""
Parse data csvs to aggregate states

Created on Wed Aug 05 18:54:01 2015

@author: Michael
"""
#import
import csv
import re
import numpy as np

#set N tooltips
n = 5

#zip code to ansi code concordance table
states = {'AL':1,
'AK':2,
'AZ':4,
'AR':5,
'CA':6,
'CO':8,
'CT':9,
'DE':10,
'DC':11,
'FL':12,
'GA':13,
'HI':15,
'ID':16,
'IL':17,
'IN':18,
'IA':19,
'KS':20,
'KY':21,
'LA':22,
'ME':23,
'MD':24,
'MA':25,
'MI':26,
'MN':27,
'MS':28,
'MO':29,
'MT':30,
'NE':31,
'NV':32,
'NH':33,
'NJ':34,
'NM':35,
'NY':36,
'NC':37,
'ND':38,
'OH':39,
'OK':40,
'OR':41,
'PA':42,
'RI':44,
'SC':45,
'SD':46,
'TN':47,
'TX':48,
'UT':49,
'VT':50,
'VA':51,
'WA':53,
'WV':54,
'WI':55,
'WY':56}

#create dictionary by state
out = {}
outTooltip = {}
dollarAgg = {}
metadataAgg = {}

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

        #print a few examples
        '''
        if i <= 10:
            print re.search('[0-9]+',row[6]).group(0)
            print row[15]
            print (row[6]
                +' contribution to '+row[0]
                +' ('+row[1]+') '
                +'\tfrom '+row[8])
            print ''
            i += 1
        '''
        #aggregate by state, store in dict
        
        #ERROR: REMOVES NEGATIVE CONTRIBUTIONS AND TREATS THEM AS POSITIVE!
        """
        try:            
            out[row[15]] = (out.get(row[15],0) + 
                            int(re.search('[0-9]+',row[6]).group(0)))
            outTooltip[row[15]] = (outTooltip.get(row[15],[]).append(
                                    (int(re.search('[0-9]+',row[6]).group(0))
                                    ,
                                    row[6]
                                    +' contribution to '+row[0]
                                    +' ('+row[1]+') '
                                    +'\tfrom '+row[8]
                                    +'\n')))
            suceed += 1
        except:
            failed += 1
        """
        try:
            dollar = int(re.search('[0-9]+',row[6]).group(0))
            s = (row[6]
                    +' contribution to '+row[0]
                    +' ('+row[1]+') '
                    +'\tfrom '+row[8]
                    +'\n')
                    
            if row[15] not in dollarAgg:
                dollarAgg[row[15]] = [dollar]
                metadataAgg[row[15]] = [s]
            else:
                dollarAgg[row[15]].append(dollar)
                metadataAgg[row[15]].append(s)
               
            suceed +=1
        except:
            fail += 1

'''                                               
#write dict to csv
outPruned = {}
outTooltipPruned = {}

for key in out.keys():
    if key in states: #If the aggregated value is a valid state
        outPruned[states[key]] = out[key] #transfer the value, now using state numbers as the key
        outTooltipPruned[states[key]] = outTooltip[key]
    
with open('aggregateKeystoneStates.csv', 'wb') as f:
    writer = csv.writer(f)
    writer.writerow(['id','dollar','tooltiptext'])
    for key, value in outPruned.items():
        writer.writerow([key, value,outTooltipPruned[key]])
'''
#write dict to csv
out = {}
outTooltip = {}

for key in dollarAgg.keys():
    if key in states: #If the aggregated value is a valid state
        out[states[key]] = sum(dollarAgg[key]) #transfer the value, now using state numbers as the key
        indMaxDonations = np.argsort(dollarAgg[key])[-n:]
        outTooltip[states[key]] = (
            str(n) 
            +' largest donations:\n'
            +''.join([metadataAgg[key][ind] for ind in indMaxDonations]))
      
with open('aggregateKeystoneStates.csv', 'wb') as f:
    writer = csv.writer(f)
    writer.writerow(['id','dollar','tooltiptext'])
    for key, value in out.items():
        writer.writerow([key, value,outTooltip[key]])
