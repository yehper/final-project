---
title: Roles and Policies Definition
author: Yehonathan Peretz & Noam Chen
date: \today
geometry:
- top=30mm
- right=20mm
- left=20mm
- bottom=30mm
header-includes: |
 \usepackage{float}
 \let\origfigure\figure
 \let\endorigfigure\endfigure
 \renewenvironment{figure}[1][2] {
    \expandafter\origfigure\expandafter[H]
 }  {
    \endorigfigure
 }
---

## Environment Model
We define the testing area as 3 nested rectangles around the same center:

1. **Sight area** - Our central computer can detect agents and attackers throughout this area.  
2. **Fight area** - Our agents will move only inside the boundaries of this rectangle.  
3. **Protected zone** - Intrusion by attackers to this area will result in loss.  

At each time unit, the central computer will divide the area into Voronoi cells according to the position of the different participants (agent and attackers)

## Robot policies
We are dividing the roles of the Robots into 2 main roles.  
For each role we define it's policies for handling situation.  
The role of each agent will be determined by his understanding of the area layout in the current situation in the following manner:  

 - The agent's Voronoi cell contains part of the protected zone - The agent will take the role of keeper.  
 - Otherwise - The agent will take the role of chaser.

### Keepers
The Keepers priority is to defend the protected zone, and will do it in the following way:

#### Policies
Generally keepers' land coverage is defined by their distance from other potential attackers.  
Therefore, if an attacker gets closer to the keeper, the latter loses coverage, and needs to compensate by moving forward in order to keep the Voronoi boundary at approximately the same place.

For that purpose we define 2 policies in which the keepers will operate:

1. **Passive Defense:**  
    * state: The keeper is not the closest neighbor to any of the attackers.
    * operation:
        - If the area is not covered, move in a direction that will maximize cover of exposed area.
        - If protected maximize Voronoi coverage around protected area.
2. **Active Defense:**
    * state: The keeper is the closest neighbor of an attacker.
    * operation: 
        - The keeper will move towards the attacker.

## Chasers
The Chasers consider themselves as such if there are enough keepers to cover the protected area.

### Policies

1. **Active-chase:**  
    * state: Chaser shares Voronoi boundary with an attacker
    * operation:
        - The chaser will move towards the middle of the boundary.
2. **Reserve:**
    * state: The Chaser does not share Voronoi boundary with an attacker, and a keeper does share a boundary with an attacker
    * operation: 
        - The Chaser will move towards the attacker
3. **Stand-by:**
    * state: The Chaser does not share Voronoi boundary with an attacker, and no keeper shares a boundary with an attacker
    * operation: 
        - The chaser will move towards a pre-defined area (e.g. 1/3 of the distance between the center of the field and the edge) and will stay their until change of state.

## Pseudo-code

```
1. For each agent:
    2. Get Voronoi map from central computer
    3. if protected area is inside Voronoi cell  
        1. set role as keeper
    4. else
        1. set role as chaser
    5. Determine policy according to situation
    6. Move according to policy.
```
