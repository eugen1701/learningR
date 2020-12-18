
# A handy way of creating sequences is the operator :
# Sequence from 1 to 5
1:5
#ans> [1] 1 2 3 4 5

# Storing some vectors
vec <- c(-4.12, 0, 1.1, 1, 3, 4)
vec
#ans> [1] -4.12  0.00  1.10  1.00  3.00  4.00

# Entry-wise operations
vec + 1 #add 1 to all the elements, but doesn't save
#ans> [1] -3.12  1.00  2.10  2.00  4.00  5.00
vec^2#lift to the power but not save
#ans> [1] 16.97  0.00  1.21  1.00  9.00 16.00

# If you want to access a position of a vector, use [position]
vec[6]
#ans> [1] 4

# You also can change elements

vec[2] <- -1 #it save the change
vec
#ans> [1] -4.12 -1.00  1.10  1.00  3.00  4.00

# If you want to access all the elements except a position, use [-position]
vec[-2]
#ans> [1] -4.12  1.10  1.00  3.00  4.00

# Also with vectors as indexes
vec[1:3]
#ans> [1] -4.12 -1.00

# And also
vec[-c(1, 2)]
#ans> [1] 1.1 1.0 3.0 4.0

#Do the following:
x <- c(1,7,3,4)
y <- c(100:1)
x[3] + y[4];cos(x[3])+sin(x[2])*exp(-y[2])
x[3] = 0
y[2] = -1
z = y[x+1]

rm(z)
