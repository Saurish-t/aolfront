//
//  SearchResultCard.swift
//  acl2
//
//  Created by Saurish Tripathi on 5/17/25.
//


import SwiftUI

struct SearchResultCard: View {
    let result: SearchResult

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(result.title)
                .font(.title3)
                .fontWeight(.semibold)

            if !result.description.isEmpty {
                Text(result.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }

            Text(result.timestamp)
                .font(.caption)
                .foregroundColor(.gray)
            /*
            if !result.people.isEmpty {
                HStack(spacing: 10) {
                    ForEach(result.people.prefix(3), id: \.name) { person in
                        HStack(spacing: 4) {
                            Image(systemName: "person.fill")
                                .font(.caption)
                            Text(person.name)
                                .font(.caption)
                        }
                        .padding(6)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    }
                }
            }

            if !result.tags.isEmpty {
                HStack(spacing: 6) {
                    ForEach(result.tags.prefix(3), id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
            }
             */
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}
