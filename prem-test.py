#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 22 15:25:46 2018

@author: jdozal
"""
import pandas as pd
# reading PREM cvs file, storing into pandas DataFrame
prem = pd.read_csv('PREM500.csv', names=['radius(m)','density(kg/m^3)','Vpv(m/s)','Vsv(m/s)','Q-kappa','Q-mu','Vph(m/s)','Vsh(m/s)','eta'])

g = []
# Radius of earth in km
R = 6371

rad = prem["radius(m)"]/1000
prem["radius(km)"] = rad

# calculating gravity at depth d
for index, row in prem.iterrows():
    currG = 9.81*(1-(row["radius(km)"]/R))
    g.append(currG)

# calculating gravity at depth d, shorter version, less decimals
testG = 9.81*(1-(prem["radius(km)"]/R))

# adding column g to PREM
prem["g"] = testG

# column for Gravitational Potential Energy 
#E=prem["density(kg/m^3)"]*prem["g"]*prem["radius(m)"]

# adding E to prem
#prem["E"] = E

# Keeping only used columns  (optional)
prem2 = prem.drop(['Vpv(m/s)','Vsv(m/s)','Q-kappa','Q-mu','Vph(m/s)','Vsh(m/s)','eta'], axis=1)

# Creating cvs file 
prem2.to_csv('PREM_Edit.csv')