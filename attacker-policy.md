# Attacker policy

## Psudo-code:
movement of attacker i:
1. Calculate Voronoi of attacker i.
2. if there is a defender in a certain radius (e.g. 2 meters) :  
    - 2.1 if there is a defender at the right ([-pi/2,0)):  
        - 2.1.1 Rotate towards left side.  
    - 2.2 else if there is a defender at the left ([0,pi/2]):  
        - 2.1.2 Rotate towards right side.  
3. else:  
    - 3.1. Move towards the Voronoi's vertex which is closest to the protected zone  
