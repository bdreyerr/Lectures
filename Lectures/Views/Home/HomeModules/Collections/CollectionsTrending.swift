//
//  Collections.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/9/25.
//

import SwiftUI

struct CollectionsTrending: View {
    
    var collections = [
        Collection(id: "1", image: "cs2", title: "Introductory Computer Science", subText: "Freshman CS at Top Tech Schools", description: """
    Dive into foundational computer science through curated introductory courses from world-leading institutions. This collection features core CS courses modeled after first-year curricula at universities like Stanford and MIT, providing a comprehensive introduction to computational thinking, programming fundamentals, and computer systems.
    
    Students begin with essential programming concepts, data structures, and algorithms while developing strong problem-solving skills. Through hands-on projects and carefully structured assignments, they'll master fundamental concepts that form the backbone of a computer science education. The curriculum emphasizes both theoretical understanding and practical implementation, preparing students for advanced study in areas like artificial intelligence, systems design, and software engineering.
    
    Key areas covered include:
    - Programming fundamentals using Python and other industry-standard languages
    - Object-oriented programming principles and design
    - Basic algorithms and computational problem-solving
    - Introduction to computer systems and architecture
    - Data structures and abstract data types
    - Discrete mathematics and logic
    
    This collection offers the rigor and depth characteristic of elite technical institutions while remaining accessible to motivated beginners. Whether you're pursuing a career in technology or seeking to understand the foundations of modern computing, these courses provide an excellent starting point for your journey into computer science.
    """, courseIdList: ["1", "2"]),
        Collection(id: "2", image: "humanities", title: "Humanities Essentials", subText: "Mind Bending Psychology, Literature and More", description: """
Embark on a transformative journey through the fundamental questions and ideas that have shaped human civilization. This collection brings together essential courses in literature, philosophy, history, and the arts, offering a rich exploration of human thought, creativity, and cultural expression across time and cultures.

From ancient philosophical debates to masterpieces of world literature, these courses develop critical thinking, analytical writing, and deep reading skills vital for understanding our shared human experience. Students engage with timeless works that address fundamental questions about knowledge, justice, beauty, and the human condition.

Key areas covered include:
- Classical literature and epic poetry
- Ancient and modern philosophy
- Art history and aesthetic theory
- World history and civilizations
- Critical theory and textual analysis
- Comparative religion and ethics
- Cultural studies and anthropology

Through careful analysis of primary texts, engaging discussions, and thoughtful writing assignments, students develop the interpretive skills and cultural literacy essential for meaningful participation in contemporary intellectual discourse. Whether you're interested in understanding the great conversations that have shaped our world or seeking to develop sophisticated analytical and communication skills, these courses provide a solid foundation in humanistic inquiry and expression.
""", courseIdList: ["1", "2"]),
        Collection(id: "3", image: "math", title: "Ultimate Math", subText: "High Complexity Math to Break your Brain", description: """
Journey through mathematics from foundational concepts to advanced theoretical frontiers. This comprehensive collection builds mathematical mastery through carefully sequenced courses covering pure and applied mathematics, designed to develop both computational fluency and deep conceptual understanding.

Students progress from essential calculus and linear algebra through abstract algebra, real analysis, and beyond, building the robust mathematical foundation needed for advanced work in science, engineering, and mathematical research. Each course emphasizes rigorous proof techniques, problem-solving strategies, and the interconnections between different mathematical domains.

Key areas covered include:
- Single and multivariable calculus
- Linear algebra and matrix theory
- Abstract algebra and group theory
- Real and complex analysis
- Differential equations
- Number theory and cryptography
- Topology and geometric analysis
- Probability theory and statistics

Through challenging problem sets, theoretical explorations, and practical applications, students develop mathematical maturity and abstract reasoning skills essential for advanced mathematical thinking. Whether you're preparing for a career in mathematics, physics, or other quantitative fields, or simply seeking to master the language of the universe, this collection provides a thorough foundation in mathematical thought and methods.
""", courseIdList: ["1", "2"])
    ]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("Trending Collections")
                    .font(.system(size: 14, design: .serif))
                    .bold()
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    let groupedUniversities = stride(from: 0, to: collections.count, by: 2).map { index in
                        Array(collections[index..<min(index + 2, collections.count)])
                    }
                    
                    ForEach(groupedUniversities.indices, id: \.self) { groupIndex in
                        let group = groupedUniversities[groupIndex]
                        VStack(spacing: 16) {
                            ForEach(group, id: \.id) { collection in
                                CollectionCard(collection: collection)
                            }
                        }
                        .padding(.trailing, 10)
                    }
                }
            }
        }
        .frame(maxHeight: 220)
        
        
        
        
//        HStack {
//            Text("Trending Collections")
//                .font(.system(size: 14, design: .serif))
//                .bold()
//            
//            Spacer()
//        }
//        
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack {
//                let groupedCollections = stride(from: 0, to: collections.count, by: 2).map { index in
//                    Array(collections[index..<min(index + 2, collections.count)])
//                }
//                
//                ForEach(groupedCollections.indices, id: \.self) { groupIndex in
//                    let group = groupedCollections[groupIndex]
//                    VStack {
//                        ForEach(group, id: \.id) { collection in
//                            CollectionCard(collection: collection)
//                        }
//                        Spacer()
//                    }
//                }
//            }
//        }
         
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 10) {
//                
//                CollectionCard(collection: collections[0])
//                
//                CollectionCard(collection: collections[1])
//                
//                CollectionCard(collection: collections[2])
//                
//            }
//        }
    }
}

#Preview {
    CollectionsTrending()
}
