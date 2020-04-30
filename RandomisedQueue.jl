module randomisedQueue
	#https://coursera.cs.princeton.edu/algs4/assignments/queues/specification.php
	#Implement randomisedQueue
	#where element to be popped is chosen uniformly at random
	#-------Struct------------
	mutable struct Queue
		data::AbstractArray{Any}
		Size::Int
		Capacity::Int
		last_idx::Int
	end
	
	#-------Functions---------
	function is_empty(v::Queue)::Bool
		# null_elem = true
		# for elem in v
			# if elem == nothing
				# continue
			# else
				# null_elem = false
				# break
			# end
		# end
		# return null_elem
		if v.Size == 0
			return true
		else
			return false
		end
	end
	
	function resize(v::Queue,newsize)
		tmp = v.data
		#v.data = Array{typeof(v.data)}(undef,length(v.data)*2)
		v.Capacity += newsize
		v.data = [nothing for i=1:v.Capacity]
		
		for i=1:length(tmp)
			v.data[i] = tmp[i]
		end
		return v
	end
	
	function reduce_capacity(v::Queue)
		if v.Size <= floor(Int,v.Capacity/4)
			v = resize(v,-floor(Int,v.Capacity/2))
		end
		return v
	end
	
	
	function enqueue(v::Queue,x::Any)
		if v.Size == v.Capacity
			v = resize(v,v.Capacity)
		end
		#v.data.push!(v,x)
		#v.Size += 1
		if v.Size == 0
			append!(v.data,x)
		end
		v.data[v.Size+1] = x 
		v.Size += 1
		v.last_idx +=1 
		
	end
	
	function dequeue(v::Queue)
		#deleteat!(v.data,1)
		idx = rand(1:v.Size)
		v.data[idx] = nothing
		v.Size -= 1
		v = reduce_capacity(v)
	end
	
	
	function get_user_input(prompt)
		println("Enter element or . to stop")
		input = readline()
		if input != " "
			return input
		else
			println("[WARNING] input is empty string")
			return input
		end
	end
	
	function run_module(v::Queue)
		
		while true
			input = get_user_input("Enter element: ")
			if input[1] == '.'
				break
			else
				#add_first(v,parse(Int,input))
				enqueue(v,parse(Int,input))
			end
		end
				
		return v
	end

	#-------Main------------
	begin
		println("Start")
		
		queue = Queue(Int[],0,1,0)
		println("Queue: ",queue)
		queue = run_module(queue)
		println("Queue: ",queue)
		dequeue(queue)
		println("Queue: ",queue)
		dequeue(queue)
		println("Queue: ",queue)
		dequeue(queue)
		println("Queue: ",queue)
		dequeue(queue)		
		println("End")
	end
	
end
