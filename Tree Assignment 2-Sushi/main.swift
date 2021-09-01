//
//  main.swift
//  Tree Assignment 2-Sushi
//
//  Created by Dylan Park on 2021-08-24.
//

import Foundation

func containsAll(array: [Int], set: Set<Int>) -> Bool {
    for i in array {
        if !set.contains(i) {
            return false
        }
    }
    return true
}

func sushi() {
    struct Restaurant {
        let number: Int
        let adjacent: [Int]
        let previousRestaurant: Int
        let traveledRestaurants: Set<Int>
        let travelTime: Int
    }
    
    print("Please input for Sushi Restaurant Reviews")
    let firstLine = readLine()!.split(separator: " ").map { Int($0) }
    let numOfN = firstLine[0]!
    let numOfM = firstLine[1]!
    let indexesOfM: [Int] = readLine()!.split(separator: " ").map { Int($0)! }
    
    var smallestTravelTime = 2 * numOfN
    
    var paths = [[Int]](repeating: [Int](repeating: 0, count: 0), count: numOfN)
    
    for _ in 1..<numOfN {
        let pathInput = readLine()!.split(separator: " ").map { Int($0) }
        paths[pathInput[0]!].append(pathInput[1]!)
        paths[pathInput[1]!].append(pathInput[0]!)
    }
    
    func findSmallestTravelTime(startRestaurant: Restaurant) {
        let q = Queue<Restaurant>()
        q.enqueue(item: startRestaurant)
        
        while !q.isEmpty() {
            
            let sq = q.dequeue()!
            let number = sq.number
            let adjacentRestaurants: [Int] = sq.adjacent
            let previousReataurant: Int = sq.previousRestaurant
            var traveledRestaurants: Set<Int> = sq.traveledRestaurants
            let travelTime = sq.travelTime
            traveledRestaurants.insert(number)
            
            if travelTime > smallestTravelTime {
                break
            }
            if containsAll(array: indexesOfM, set: traveledRestaurants) {
                if travelTime < smallestTravelTime {
                    smallestTravelTime = travelTime
                }
                break
            }

            for i in 0..<adjacentRestaurants.count {
                let adjacentRestaurantNumber = adjacentRestaurants[i]
                if adjacentRestaurantNumber == previousReataurant && adjacentRestaurants.count > 1 {
                    continue
                }
                q.enqueue(item: Restaurant(number: adjacentRestaurantNumber, adjacent: paths[adjacentRestaurantNumber], previousRestaurant: number, traveledRestaurants: traveledRestaurants, travelTime: travelTime + 1))
            }
        }
    }
    for restaurant in indexesOfM {
        let emptySet: Set<Int> = []
        findSmallestTravelTime(startRestaurant: Restaurant(number: restaurant, adjacent: paths[restaurant], previousRestaurant: -1, traveledRestaurants: emptySet, travelTime: 0))
    }
    print(smallestTravelTime)
}

sushi()
/*
 Sample Input 1
8 2
5 2
0 1
0 2
2 3
4 3
6 1
1 5
7 3
 Sample Output 1
3
 
 Sample Input 2
8 5
0 6 4 3 7
0 1
0 2
2 3
4 3
6 1
1 5
7 3
 Sample Output 2
7
 */
