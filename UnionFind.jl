mutable struct Site
	id::Int
	root::Int
	i::Int
	j::Int
	status::Bool
end

#---------Methods----------------------

function check_connection(p::Site,q::Site)::Bool
	return p.root == q.root
end

function connect(p::Site,q::Site)
	
	if p.status && q.status
		if sz[p.id] < sz[q.id]
			p.root= q.root
			sz[q.id] = sz[q.id] + sz[p.id]
		else
			q.root= p.root
			sz[p.id] = sz[p.id] + sz[q.id]
		end
	end
end

function count_sites()
	open_count = 0
	total_count = 0
	for g in grid
		if g.status
			open_count +=  1
		end
		total_count += 1
	end
	return (open_count,total_count)
end

function locate_sites()
	
	for g in grid
		g.i = (g.id-2) ? Int(sqrt(length(grid)))
		g.j = (g.id-2) % Int(sqrt(length(grid)))

	end
end

function open_sites()
	max_val = 50	#abitrary value
	for g in grid
		msk = rand(1:max_val)
		g.status = (msk % 3 == 0) ? true : false
	end
end

function percolation()
	open_sites()
	
	len = length(grid)
	locate_sites()
	
	
	#Connect top row to top_site
	p = top_site
	for i=1:Int(sqrt(len))
		connect(p,grid[i])
	end
	
	#connect all open sites
	# for i=1:len-1
		# connect(grid[i],grid[i+1])
	# end
	
	for g in grid
		for c=2:len
			if (abs(grid[c].i - g.i) <= 1 && grid[c].j == g.j) || 
				(abs(grid[c].j - g.j) <= 1 && grid[c].j == g.i)
				connect(g,grid[c])
			end
		end
	end
	
	#Connect bottom row to bottom_site
	p = bottom_site
	i=len
	counter=Int(sqrt(len))
	while counter >= 1
		connect(p,grid[i])
		i -= 1
		counter -= 1
	end
	
	#Check if grid is percolated
	percolated = check_connection(top_site,bottom_site)
	#visualise()
	return percolated
	
end

function visualise()
	n = Int(sqrt(length(grid)))
	
	for i=0:n-1
		for j=0:n-1
			print(grid[(n*i)+j+1].status,"\t")
		end
		println("")
	end
	
end

# function thresh_mean(x::AbstractArray{Float64})
	# sum_x = sum(x)
	# return sum_x / length(x)
# end

function thresh_deviation(x::Array{Float64},mean_thresh::Float64)
	sum_x = 0
	for i in x
		sum_x += (i-mean_thresh)^2
	end
	return sum_x / (length(x)-1)
end

#--------MainBody--------------------

begin
	println("Size of N:")
	n = parse(Int,readline())
	len = n * n
	println("Num of trials:")
	T = parse(Int,readline())
	percolation_thresholds = Array{Float64}(undef,T)
	
	for i=1:T
		global top_site = Site(1,1,0,0,true)
		global grid = [Site(i,i,i,i,false) for i=2:len+1]
		global bottom_site = Site((len+2),(len+2),0,0,true)
		global sz = ones(Int,len+2)
		
		percolated = percolation()
		
		if percolated
			num_open_sites = count_sites()[1]
			total_sites = count_sites()[2]
			percolation_thresholds[i] = (num_open_sites / total_sites)
		else
			percolation_thresholds[i] = 0
		end
	end
	using Statistics
	
	#x_mean = mean(percolation_thresholds)
	#equal_sizes(arr::Array{Any,Any},C::Int64) = return (length(arr) == C)
	#@assert  equal_sizes(percolation_thresholds,T),"Missing values"
	if length(percolation_thresholds) != T
		println("Missing values",length(percolation_thresholds))
		exit()
	end
	x_mean = sum(percolation_thresholds)/T
	#deviation = std(percolation_thresholds,corrected=true,mean=x_mean)
	deviation = thresh_deviation(percolation_thresholds,x_mean)
	confidenceLo = x_mean - (1.96*deviation)/sqrt(T)
	confidenceHi = x_mean + (1.96*deviation)/sqrt(T)
	
	println("Mean: ",x_mean)
	println("Deviation: ",deviation)
	println("ConfidenceLo: ",confidenceLo)
	println("ConfidenceHi: ",confidenceHi)
	
	println("End")
	
end
