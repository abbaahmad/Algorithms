module MyDeque
	#https://coursera.cs.princeton.edu/algs4/assignments/queues/specification.php
	#Implement Deque 
  
	#-------Struct------------
	mutable struct Deque
		data::AbstractArray{Any}
		Size::Int
		Capacity::Int
		last_idx::Int   #Not needed if we shift elements after pop
	end
	
	#-------Functions---------
	function is_empty(v::Deque)::Bool
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
	
	function resize(v::Deque,newsize)
		tmp = v.data
		#v.data = Array{typeof(v.data)}(undef,length(v.data)*2)
		v.Capacity += newsize
		v.data = [nothing for i=1:v.Capacity]
		
		for i=1:length(tmp)
			v.data[i] = tmp[i]
		end
		return v
	end
	
	function reduce_capacity(v::Deque)
		if v.Size <= floor(Int,v.Capacity/4)
			v = resize(v,-floor(Int,v.Capacity/2))
		end
		return v
	end
	
	function add_first(v::Deque,x::Any)
		if v.Size == v.Capacity
			v = resize(v,v.Capacity)
		end
		#pushfirst!(v.data,x)
		v.Size += 1
		v.last_idx += 1
		println("Size is ",v.Size)
		println("Capacity: ",v.Capacity)
		if v.Size == 1
			append!(v.data,x)
		else
			tmp = v.data
			v.data = [nothing for i=1:v.Capacity]
			v.data[1] = x
			for i=2:v.Size
				v.data[i] = tmp[i-1]
			end
		end
		return v
		
	end
	
	function add_last(v::Deque,x::Any)
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
	
	function remove_first(v::Deque)
		#deleteat!(v.data,1)
		v.data[1] = nothing
		v.Size -= 1
		v = reduce_capacity(v)
	end
	
	function remove_last(v::Deque)
		#pop!(v.data)
		v.data[v.last_idx] = nothing
		v.Size -= 1
		v.last_idx -= 1
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
	
	function run_module(v::Deque)
		
		while true
			input = get_user_input("Enter element: ")
			if input[1] == '.'
				break
			else
				#add_first(v,parse(Int,input))
				add_last(v,parse(Int,input))
			end
		end
		
		return v
	end

	#-------Main------------
	begin
		println("Start")
		
		deque = Deque(Int[],0,1,0)
		println("Deque: ",deque)
		deque = run_module(deque)
		println("Deque: ",deque)
		remove_first(deque)
		println("Deque: ",deque)
		remove_last(deque)
		println("Deque: ",deque)
		remove_last(deque)
		println("Deque: ",deque)
		
		println("End")
	end
	
end
