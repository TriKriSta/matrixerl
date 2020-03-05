-module(matrixerl_test).

-include_lib("eunit/include/eunit.hrl").

-import(matrixerl, [sum/1,
		    sum/2,
		    subtraction/2,
		    multiply/2,
		    shape/1,
		    isCorrect/1,
		    slice/2,
		    transpose/1,
		    join/2,
		    join/3,
		    dot/2,
		    dot/3,
		    dotVector/2,
		    matrixNormalForm/1,
		    minor/3,
		    random/1,
		    nth/3,
		    numers/2,
		    stringListToMatrix/2,
		    isVector/1,
		    isVector/2,
		    det/1]).

%% add test for MatrixNormalForm

sum_test() ->
    ArrA = [[1,1,1],[2,2,2]],
    ArrB = [[3,3,3],[4,4,4]],
    
    E = [[4,4,4],[6,6,6]],
    
    ?assertEqual(E, sum(ArrA, ArrB)),
    
    N = 3,
    E1 = [[4,4,4],[5,5,5]],
    
    ?assertEqual(E1, sum(ArrA, N)),
    ?assertEqual(E1, sum(N, ArrA)),
    
    Arr2 = [1,2,3],
    E2 = [4,5,6],
    
    ?assertEqual(E2, sum(Arr2, N)),
    ?assertEqual(E2, sum(N, Arr2)),
    ?assertEqual(10, sum(3, 7)),
    
    Arr3 = [[1],
	    [3],
	    [5],
	    [7]],
    
    E3 = [[3],
	  [5],
	  [7],
	  [9]],
    
    ?assertEqual(E3, sum(Arr3, 2)),
    
    Arr4 = [[3]],
    E4 = [[7]],
    
    ?assertEqual(E4, sum(Arr4, 4)).

sumMatrix_test() ->
    A1 = [1,2,3,4],
    E1 = 10,

    ?assertEqual(E1, sum(A1)),
  
    A2 = [[1],
	  [2],
	  [3],
	  [4]],
    
    E2 = 10,
    
    ?assertEqual(E2, sum(A2)),

    A3 = [[1,3],
	  [2,-1],
	  [3,0],
	  [4,11]],
    
    E3 = 23,
    
    ?assertEqual(E3, sum(A3)),    
    
    A4 = [[12]],
    
    E4 = 12,
    
    ?assertEqual(E4, sum(A4)).

subtraction_test() ->
    ArrA = [[1,1,1],[5,5,5]],
    ArrB = [[3,3,3],[4,4,4]],
    
    E = [[-2,-2,-2],[1,1,1]],
    
    ?assertEqual(E, subtraction(ArrA, ArrB)),
    
    N = 3,
    E1 = [[-2,-2,-2],[2,2,2]],
    
    ?assertEqual(E1, subtraction(ArrA, N)),
    ?assertEqual(E1, subtraction(N, ArrA)),
    
    Arr2 = [1,2,3],
    E2 = [-2,-1,0],
    
    ?assertEqual(E2, subtraction(Arr2, N)),
    ?assertEqual(E2, subtraction(N, Arr2)),
    ?assertEqual(6, subtraction(13, 7)).

multiply_test() ->
    ArrA = [[1,1,1],[2,2,2]],
    ArrB = [[3,3,3],[4,4,4]],
    
    E = [[3,3,3],[8,8,8]],
    
    ?assertEqual(E, multiply(ArrA, ArrB)),
    
    N = 3,
    E1 = [[3,3,3],[6,6,6]],
    
    ?assertEqual(E1, multiply(ArrA, N)),
    ?assertEqual(E1, multiply(N, ArrA)),
    
    Arr2 = [1,2,3],
    E2 = [3,6,9],
    
    ?assertEqual(E2, multiply(Arr2, N)),
    ?assertEqual(E2, multiply(N, Arr2)),
    ?assertEqual(21, multiply(3, 7)).

isCorrect_test() ->
    Arr = [[2, 2], [2, 2]],
    Arr1 = [[2, 2], [2]],
    
    [?assertEqual(true, isCorrect(Arr)),
     ?assertEqual(false, isCorrect(Arr1))].

slice_test() ->
    Arr = [[1,2,3],
	   [1,2,3]],
    Slice = [1,1,1,3],
    E = [1,2,3],
    ?assertEqual(E, slice(Arr, Slice)),

    Slice1 = [10,10,1,3],
    E1 = [],
    ?assertEqual(E1, slice(Arr, Slice1)),
    
    Arr3 = [[1,2,3],
	   [1,2,3]],
    Slice3 = [1,2,5,5],
    E3 = [[2,3],[2,3]],
    ?assertEqual(E3, slice(Arr3, Slice3)),
    
    Arr4 = [1,2,3,4,5,6],
    Slice4 = [3,4],
    E4 = [3,4,5,6],
    ?assertEqual(E4, slice(Arr4, Slice4)),
    
    Arr5 = [1,2,3,4,5,6],
    Slice5 = [1,1,2,2],
    E5 = [1,2],
    ?assertEqual(E5, slice(Arr5, Slice5)),
    
    Arr6 = Arr5,
    Slice6 = [2,2,1,1],
    E6 = [],
    ?assertEqual(E6, slice(Arr6, Slice6)),
    
    Arr7 = [[1,2,3,4,5,6,7],
	    [9,8,7,6,5,4,3],
	    [3,4,5,6,7,8,9],
	    [9,8,7,6,5,4,3],
	    [2,3,4,5,6,7,8],
	    [0,1,2,3,4,5,6],
	    [7,6,5,4,3,2,1]],
    Slice7 = [2,2,1,1],
    E7 = [8],
    ?assertEqual(E7, slice(Arr7, Slice7)),
    
    Slice7_1 = [3,3,2,3],
    E7_1 = [[5,6,7],
	    [7,6,5]],
    ?assertEqual(E7_1, slice(Arr7, Slice7_1)),

    Slice7_2 = [5,5,3,3],
    E7_2 = [[6,7,8],
	    [4,5,6],
	    [3,2,1]],
    ?assertEqual(E7_2, slice(Arr7, Slice7_2)),

    Slice7_3 = [5,5,2,2],
    E7_3 = [[6,7],
	    [4,5]],
    ?assertEqual(E7_3, slice(Arr7, Slice7_3)),

    Slice7_4 = [5,5,5,5],
    E7_4 = [[6,7,8],
	    [4,5,6],
	    [3,2,1]],
    ?assertEqual(E7_4, slice(Arr7, Slice7_4)),
    
    Slice7_5 = [1,1,0,0],
    ?assertEqual([], slice(Arr7, Slice7_5)),
    
    Slice7_6 = [1,1,1,0],
    ?assertEqual([], slice(Arr7, Slice7_6)),
    
    Slice7_7 = [1,1,0,1],
    ?assertEqual([], slice(Arr7, Slice7_7)).
    
transpose_test() ->
    A = [[4], [5], [6]],
    T = [4, 5, 6],

    ?assertEqual(T, transpose(A)).

join_test() ->
    A = [1, 2],
    B = [3, 4],
    
    E = [1, 2, 3, 4],
    E_1 = [[1, 2],
	   [3, 4]],
    
    ?assertEqual(E, join(A, B)),
    ?assertEqual(E, join(A, B, horizontal)),
    ?assertEqual(E_1, join(A, B, vertical)),

    A1 = [[1],
	  [2]],
    B1 = [[3],
	  [4]],
    
    E1 = [[1, 3],
	  [2, 4]],
    E1_1 = [[1],
	    [2],
	    [3],
	    [4]],
    
    ?assertEqual(E1, join(A1, B1)),
    ?assertEqual(E1, join(A1, B1, horizontal)),
    ?assertEqual(E1_1, join(A1, B1, vertical)),
    
    A2 = [1, 2, 3],
    B2 = [[4, 5, 6],
	  [7, 8, 9]],
    
    E2 = [[1, 2, 3],
	  [4, 5, 6],
	  [7, 8, 9]],
    
    E2_1 = [[4, 5, 6],
	    [7, 8, 9],
	    [1, 2, 3]],
    
    ?assertEqual(E2, join(A2, B2, vertical)),
    ?assertEqual(E2_1, join(B2, A2, vertical)),
    
    A3 = [1, 2, 3],
    B3 = [],
    
    ?assertEqual(A3, join(A3, B3)),
    ?assertEqual(A3, join(A3, B3, horizontal)),
    ?assertEqual(A3, join(A3, B3, vertical)),
    ?assertEqual(A3, join(B3, A3)),
    ?assertEqual(A3, join(B3, A3, horizontal)),
    ?assertEqual(A3, join(B3, A3, vertical)),

    A4 = [[1, 2, 3],
	  [1, 2, 2]],
    
    B4 = [],
    
    ?assertEqual(A4, join(A4, B4)),
    ?assertEqual(A4, join(A4, B4, horizontal)),
    ?assertEqual(A4, join(A4, B4, vertical)),
    ?assertEqual(A4, join(B4, A4)),
    ?assertEqual(A4, join(B4, A4, horizontal)),
    ?assertEqual(A4, join(B4, A4, vertical)).
    

dot_test() ->
    A = [1, 2, 3],
    B = [4, 5, 6],
    ?assertError(_, dot(A, B)),

    A1 = [1, 2, 3],
    B1 = [[4], [5], [6]],
    E1 = 32,
    ?assertEqual(E1, dot(A1, B1)),

    A2 = [[1, 2, 3],
	  [1, 2, 3],
	  [1, 2, 3],
	  [1, 2, 3]],

    B2 = [[1,2,3,4],
	  [1,2,3,4],
	  [1,2,3,4]],

    E2 = [[6,12,18,24],
	  [6,12,18,24],
	  [6,12,18,24],
	  [6,12,18,24]],

    ?assertEqual(E2, dot(A2, B2)),
    
    A5 = A2,
    B5 = 3,
    E5 = [[3,6,9],
	  [3,6,9],
	  [3,6,9],
	  [3,6,9]],

    ?assertEqual(E5, dot(B5, A5)),
    ?assertEqual(E5, dot(A5, B5)),
    ?assertEqual(42, dot(7, 6)),
    
    A6 = [[1],
	  [2]],
    B6 = [1,2],
    E6 = [[1,2],
	  [2,4]],
    ?assertEqual(E6, dot(A6, B6)),
    
    A7 = [1,2],
    B7 = [[1,2],
	  [3,4]],
    
    E7 = [7, 10],
    ?assertEqual(E7, dot(A7, B7)),
    
    A8 = [2],
    B8 = [[1,2],
	  [1,2]],
    
    E8 = [[2,4],
	  [2,4]],
    ?assertError(_, dot(A8, B8)),
    ?assertEqual(E8, dot(A8, B8, one)),
    
    A9 = [[1,2,3],
	  [4,5,6],
	  [7,8,9],
	  [8,7,6]],
    
    B9 = [[1],
	  [2],
	  [3]],
    
    E9 = [[14],
	  [32],
	  [50],
	  [40]],

    ?assertEqual(E9, dot(A9, B9)).
    

dotVector_test() ->
    A = [1, 2, 3],
    B = [4, 5, 6],
    E = 32,    
    ?assertEqual(E, dotVector(A, B)).

matrixNormalForm_test() ->
    A = [1, 2, 3],
    E = [1, 2, 3],
    
    ?assertEqual(E, matrixNormalForm(A)),
    
    A1 = [[1], [2], [3]],
    E1 = [1, 2, 3],
    
    ?assertEqual(E1, matrixNormalForm(A1)),
    
    A2 = [[1, 3], [2, 5], [3, 8]],
    E2 = [[1, 3], [2, 5], [3, 8]],
    
    ?assertEqual(E2, matrixNormalForm(A2)).

minor_test() ->
    M = [[1, 2, 3],
	 [4, 5, 6],
	 [7, 8, 9]],
    
    ?assertEqual(-3, minor(1, 1, M)),
    ?assertEqual(-12, minor(2, 2, M)),
    ?assertEqual(-3, minor(3, 3, M)),
    ?assertEqual(-6, minor(2, 1, M)).

random_test() ->
    Shape1 = [1, 11],
    Arr1 = random(Shape1),
    ShapeE1 = Shape1,
    ?assertEqual(ShapeE1, shape(Arr1)),
    
    Shape2 = [11, 1],
    Arr2 = random(Shape2),
    ShapeE2 = [1, 11],
    ?assertEqual(ShapeE2, shape(Arr2)),
    
    Shape3 = [11, 10],
    Arr3 = random(Shape3),
    ShapeE3 = Shape3,
    ?assertEqual(ShapeE3, shape(Arr3)),

    Shape4 = [1, 1],
    N = random(Shape4),
    ?assertEqual(is_number(N), true).

nth_test() ->
    M = [[1, 2],
	 [3, 4]],
    
    ?assertEqual(3, nth(2, 1, M)),
    
    M1 = [[1, 2, 3],
	  [4, 5, 6], 
	  [7, 8, 9]],
    
    ?assertEqual(3, nth(1, 3, M1)),
    ?assertEqual(1, nth(1, 1, M1)),
    ?assertEqual(9, nth(3, 3, M1)),
    ?assertEqual(5, nth(2, 2, M1)).

numers_test() ->
    Shape = 1,
    Num = 3,
    E = [3],
    
    ?assertEqual(E, numers(Shape, Num)),
    
    Shape1 = [1, 1],
    Num1 = 3,
    E1 = [3],
    
    ?assertEqual(E1, numers(Shape1, Num1)),
    
    Shape2 = 5,
    Num2 = 7,
    E2 = [7, 7, 7, 7, 7],
    
    ?assertEqual(E2, numers(Shape2, Num2)),

    Shape3 = [3, 4],
    Num3 = 7,
    E3 = [[7, 7, 7, 7],
	  [7, 7, 7, 7],
	  [7, 7, 7, 7]],
    
    ?assertEqual(E3, numers(Shape3, Num3)).    

stringListToMatrix_test() ->
    StringList = ["1,2,3","4,5,6","7,8,9"], 
    Matrix = [[1,2,3],[4,5,6],[7,8,9]],
    
    ?assertEqual(Matrix, stringListToMatrix(StringList, ",")),
    
    StringList1 = ["1.1,2.2,3.3","4.4,5.5,6.6","7.7,8.8,9.9"], 
    Matrix1 = [[1.1,2.2,3.3],[4.4,5.5,6.6],[7.7,8.8,9.9]],
    
    ?assertEqual(Matrix1, stringListToMatrix(StringList1, ",")).

isVector_test() ->
    A = [1, 2, 3, 4],
    
    ?assertEqual(true, isVector(A)),
    ?assertEqual(true, isVector(A, row)),
    ?assertEqual(false, isVector(A, column)),
    
    A1 = [[1],
	  [2],
	  [3],
	  [4]],

    ?assertEqual(true, isVector(A1)),
    ?assertEqual(false, isVector(A1, row)),
    ?assertEqual(true, isVector(A1, column)),

    A2 = [[1, 2],
	  [2, 3],
	  [3, 4],
	  [4, 5]],

    ?assertEqual(false, isVector(A2)).

det_test() ->
    M = [[1, 2, 3],
	 [2, 3, 4]],
    
    A = {error, "wrong data"},
    ?assertEqual(A, det(M)),
    
    M1 = [[1, 2, 3],
	  [2, 3, 4],
	  [3, 4, 5]],
    
    A1 = 0,  
    ?assertEqual(A1, det(M1)),
    

    M2 = [[3, 4],
	  [-1, 7]],
    
    A2 = 25,
    ?assertEqual(A2, det(M2)),

    M3 = [[2, -1, 2, 1],
	  [4, 5, -4, 4],
	  [9, 5, 7, 1],
	  [4, 2, 8, 3]],
    
    A3 = 728,
    ?assertEqual(A3, det(M3)),

    M4 = [[2, 3, 4, 3, 4],
	  [-1, 7, 1, 0, 11],
	  [3, 7, 1, 8, 2],
	  [1, 3, 9, -5, 2],
	  [2, 4, 7, 4, 6]],
    
    A4 = -3435,
    ?assertEqual(A4, det(M4)),
    
    M5 = [[1, 4, -4, 9, 10, 1],
	  [3, 1, 8, -1, 2, 6],
	  [-1, 3, 5, 2, 6, 8],
	  [9, 7, 1, 9, 3, 6],
	  [2, 8, 4, 6, 5, 5],
	  [1, 8, 5, 5, 5, 4]],
    
    A5 = -195,
    ?assertEqual(A5, det(M5)).
