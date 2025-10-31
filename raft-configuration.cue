package raftconfig

import "list"

// Consul Raft Configuration Schema
// integratify requires the definition to be named #Config
#Config: {
	Servers: [...#Server] & list.MinItems(1)
	Index: int

	// Validation: Exactly one Leader must exist
	_leaders: [for s in Servers if s.Leader {s}] & list.MinItems(1) & list.MaxItems(1)

	// Validation: All LastIndex values must be identical
	// If min == max, all values are the same
	_indices: [for s in Servers {s.LastIndex}]
	_minIndex: list.Min(_indices)
	_maxIndex: list.Max(_indices)
	_minIndex: _maxIndex // Ensure min equals max
}

// Server definition - only specify fields we need to validate
// ... allows additional fields from the actual JSON
#Server: {
	Leader:    bool
	LastIndex: int & >=0
	...
}
