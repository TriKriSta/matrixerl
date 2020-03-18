-module(matrixerl).
-export([det/1,
	 dot/2,
	 dot/3,
	 dotVector/2,
	 cofactor/3,
	 isCorrect/1,
	 isVector/1,
	 isVector/2,
	 join/2,
	 join/3,
	 matrixNormalForm/1,
	 minor/3,
	 multiply/2,
	 nth/3,
	 numers/2,
	 random/1,
	 shape/1,
	 slice/2,
	 stringListToMatrix/2,
	 subtraction/2,
	 sum/1,
	 sum/2,
	 transpose/1]).

sum(Matrix) when is_number(Matrix) ->
    Matrix;
sum([First|_] = Matrix) when is_number(First) ->
    lists:sum(Matrix);
sum(Matrix) ->
    sumMatrix(0, Matrix).
    
sumMatrix(Sum, []) ->    
    Sum;
sumMatrix(Sum, [First|Tail]) -> 
    NewS = Sum + lists:sum(First),
    sumMatrix(NewS, Tail).

sum(N1, N2) ->
    Fun = fun(X, Y) -> X + Y end,
    mathFun(Fun, N1, N2).

subtraction(N1, N2) ->
    Fun = fun(X, Y) -> X - Y end,
    mathFun(Fun, N1, N2).

multiply(N1, N2) ->
    Fun = fun(X, Y) -> X * Y end,
    mathFun(Fun, N1, N2).

mathFun(Fun, N1, N2) when is_number(N1) == true, is_number(N2) == true ->
    Fun(N1, N2);

mathFun(Fun, N, Arr) when is_number(N) == true ->
    mathFun(Fun, Arr, N);

mathFun(Fun, Arr, N) when is_number(N) == true ->
    case isVector(Arr, row) of
	true ->
	    ArrN = matrixNormalForm(Arr),
	    [Fun(X, N) || X <- ArrN];
	false ->
	    FunOne = fun(X) -> Fun(X , N) end,
	    [lists:map(FunOne, X) || X <- Arr]
    end;

mathFun(Fun, Arr1, Arr2) ->
    mathFun([], Fun, Arr1, Arr2).

mathFun(Arr, _Fun, [], []) ->
    Arr;    

mathFun(Arr, Fun, [H1|T1], [H2|T2]) ->
    if
	is_list(H1) == true ->
	    NewArr = Arr ++ [mathFun([], Fun, H1, H2)],
	    mathFun(NewArr, Fun, T1, T2);
	is_list(H1) == false ->	   
	    NewArr = Arr ++ [Fun(H1, H2)],
	    mathFun(NewArr, Fun, T1, T2)
    end.

shape(Arr) when is_number(Arr) == true ->
    [];

shape([]) ->
    [0,0];

shape(Arr) ->
    shape([], Arr).

shape(D, Arr) ->
    NewD = D ++ [length(Arr)],
    [First|_] = Arr,

    case is_list(First) of
	true ->
	    shape(NewD, First);
	false ->
	    case length(NewD) =:= 1 of
		true ->
		    [1] ++ NewD;
		false ->
		    NewD
	    end
    end.

isCorrect([]) ->
    true;

isCorrect(Arr) ->
    Dim = shape(Arr),
    Res = isCorrect([], Dim, Arr),
    
    Res == [].
	    

isCorrect(_, _, []) ->
    [false];

isCorrect(_, [N|_], Arr) when N /= length(Arr) ->
    [false];

isCorrect(Res, [N|Dim], Arr) when N == length(Arr), length(Dim) == 0 ->
    ResItem = isCorrectValue(Arr),
    Res ++ ResItem;

isCorrect(Res, [N|Dim], Arr) when N == length(Arr) ->
    [First|Tail] = Arr,
    isCorrect(Res, Dim, First, Tail).

isCorrect(Res, Dim, Ver, []) ->
    ResItem = isCorrect([], Dim, Ver),
    Res ++ ResItem;

isCorrect(Res, Dim, Ver, Arr) ->
    ResItem = isCorrect([], Dim, Ver),
    [First|Tail] = Arr,
    isCorrect(Res ++ ResItem, Dim, First, Tail).
    
isCorrectValue([]) ->
    [];

isCorrectValue([First|Tail]) when is_number(First) == true ->
    isCorrectValue(Tail);

isCorrectValue([First|_]) when is_number(First) == false ->
    [false].

slice(Matrix, Indexes) when length(Indexes) == 2 -> %% NODE: add use "Indexes" how number, start with index 1
    [X,Len] = Indexes,

    Slice = lists:sublist(Matrix, X, Len),
    
    matrixNormalForm(Slice);
slice(_Matrix, [_M, _N, Rows, Columns]) when (Rows == 0) or (Columns == 0) ->
    [];
slice(Matrix, Indexes) when length(Indexes) == 4 ->
    NewIndexes = correctIndexes(Matrix, Indexes),

    case length(NewIndexes) of
	0 ->
	    [];
	2 ->
	    slice(Matrix, NewIndexes);
	4 ->
	    [Y,X,H,W] = NewIndexes,
	    Slice = slice([], Matrix, Y, X, H, W),
	    [M, _] = shape(Slice),
	    case M == 1 of
		true ->
		    matrixNormalForm(Slice);
		false ->
		    Slice
	    end
    end.

slice(Slice, _, _, _, H, _) when H == 0 ->
    Slice;

slice(Slice, Matrix, Y, X, H, W) -> 
    [Row|_] = lists:sublist(Matrix, Y, 1),
    SliceItem = slice(Row, [X, W]),
    slice(Slice ++ [SliceItem], Matrix, Y+1, X, H-1, W).    

correctIndexes(Matrix, Indexes) ->
    [Y,X,H,W] = Indexes,
    [M,N] = shape(Matrix),
    
    if	    
	(Y > M) or (X > N) -> 
	    NewIndexes = [];
	(Y+H-1 > M) or (X+W-1 > N) ->
	    case Y+H-1 > M of
		true ->
		    NewH = M - Y + 1;
		false -> 
		    NewH = H
	    end,
	    
	    case X+W-1 > N of
		true ->
		    NewW = N - X + 1;
		false ->
		    NewW = W
	    end,
	    NewIndexes = [Y, X, NewH, NewW];
	true  ->
	    NewIndexes = Indexes
    end,
    
    if
	((M == 1) or (N == 1)) and (length(NewIndexes) == 4) ->
	    if
		M == 1 ->
		    [_, Xarr, _, Warr] = NewIndexes;
		N == 1 ->
		    [Xarr, _, Warr, _] = NewIndexes;
		true ->
		    Xarr = 0,
		    Warr = 1
	     end,	    
	    [Xarr, Warr];
	true ->
	    NewIndexes
    end.

transpose(Num) when is_number(Num) == true ->
    Num;

transpose(Matrix) ->
    [M,N] = shape(Matrix),

    if
	M == 1 ->
	    transposeOneRow(Matrix);
	N == 1 ->
	    [NewMatrix|_] = transpose([], Matrix),
	    NewMatrix;
	true ->
	    transpose([], Matrix)
    end.

transpose(NewMatrix, []) ->
    NewMatrix;

transpose([], Matrix) ->
    [First|Tail] = Matrix,
    NewMatrix = transposeOneRow(First),
    transpose(NewMatrix, Tail);

transpose(NewMatrix, Matrix) ->
    [First|Tail] = Matrix,
    NewColumn = transposeOneRow(First),
    Join = join(NewMatrix, NewColumn),
    transpose(Join, Tail).

transposeOneRow(Row) ->
    transposeOneRow([], Row).

transposeOneRow(Column, []) ->
    Column;

transposeOneRow(Column, Row) ->
    [First|Tail] = Row,    
    transposeOneRow(Column ++ [[First]], Tail).

join([], Second) ->
    Second;
join(First, []) ->
    First;
join(First, Second) ->
    joinHorizontal([], First, Second).

join([], Second, _Type) ->
    Second;
join(First, [], _Type) ->
    First;
join(First, Second, horizontal) ->
    joinHorizontal([], First, Second);
join(First, Second, vertical) ->
    case isVector(First, row) of
	true ->
	    NFirst = [First];
	false ->
	    NFirst = First
    end,

    case isVector(Second, row) of
	true ->
	    NSecond = [Second];
	false ->
	    NSecond = Second
    end,

    NFirst ++ NSecond.

joinHorizontal(JoinMatrix, [], []) ->
    JoinMatrix;
joinHorizontal(JoinMatrix, First, Second) ->
    [RowFirst|TailFirst] = First,
    [RowSecond|TailSecond] = Second,
    
    case is_number(RowFirst) and is_number(RowSecond) of
	true ->
	    First ++ Second;
	false ->
	    RowJoin = RowFirst ++ RowSecond,
	    joinHorizontal(JoinMatrix ++ [RowJoin], TailFirst, TailSecond)
    end.

dot(First, Second) when is_number(First) == true; is_number(Second) == true -> %% ???
   multiply(First, Second);

dot(First, Second) ->
    [Mf, Nf] = shape(First),
    [Ms, Ns] = shape(Second),
    
    if 
	Nf /= Ms ->
	    Msg = lists:flatten(io_lib:format("Matrix by shape [~p,~p] and [~p,~p] can not be dot", [Mf,Nf,Ms,Ns])),
	    error(Msg);
	((Mf == 1) and (Nf == 1)) or ((Ms == 1) and (Ns == 1)) ->
	    dotVector(First, Second);
	(Mf == 1) and (Ns == 1) ->
	    dotVector(First, Second);
	Mf == 1 ->
	    dotArrayRow(First, Second);
	true ->
	    dotArray(First, Second)
    end.

dot(First, Second, one) ->
    [Mf, Nf] = shape(First),
    [Ms, Ns] = shape(Second),

    if
	([Mf, Nf] == [1, 1]) and ([Ms, Ns] == [1, 1]) ->
	    dot(First, Second);
	([Mf, Nf] == [1, 1]) ->
	    dotArray(Second, First);
	([Ms, Ns] == [1, 1]) ->
	    dotArray(First, Second);
	true ->
	    dot(First, Second)
    end.

dotVector(First, Second) when is_number(First) == true, is_number(Second) == true ->
   First * Second;

dotVector(First, Second) when is_number(First) == true; is_number(Second) == true -> %% add check is vector
   multiply(First, Second);

dotVector(First, Second) ->
    [Mf, Nf] = shape(First),
    [Ms, Ns] = shape(Second),
    
    if 
	(Mf > 1) and  (Nf > 1) ->
	    {error, "First element is not vector"};
	(Ms > 1) and  (Ns > 1) ->
	    {error, "Second element is not vector"};
	((Mf == 1) and (Nf == 1)) ->
	    [Num|_] = First,
	    multiply(Num, Second);
	((Ms == 1) and (Ns == 1)) ->
	    [Num|_] = Second,	
	    multiply(First, Num);
	true ->
	    NormalF = matrixNormalForm(First),
	    NormalS = matrixNormalForm(Second),
	    dotVector(0, NormalF, NormalS)
    end.

dotVector(Dot, [], []) ->
    Dot;

dotVector(Dot, First, Second) ->
    [Ff|TailF] = First,
    [Fs|TailS] = Second,
    dotVector(Dot + Ff * Fs, TailF, TailS).

dotArray(First, Second) ->
    dotArray([], First, Second).

dotArray(NewMatrix, [], _Second) ->
    NewMatrix;

dotArray(NewMatrix, First, Second) ->
    [RowFirst|TailFirst] = First,
    Row = dotArrayRow(RowFirst, Second),
    case is_number(Row) of
	true ->
	    NewRow = [Row];
	false ->
	    NewRow = Row
    end,
    dotArray(NewMatrix ++ [NewRow], TailFirst, Second).

dotArrayRow(RowFirst, Second) ->
    dotArrayRow([], RowFirst, Second).

dotArrayRow(NewRow, _RowFirst, []) ->    
    NewRow;

dotArrayRow(NewRow, RowFirst, Second) ->
    [M, N] = shape(Second),
    
    if
	(M == 1) or (N == 1) ->
	    Column = Second,
	    TailSecond = [];
	true ->
	    Column = slice(Second, [1, 1, M, 1]),
	    TailSecond = slice(Second, [1, 2, M, N-1])
    end,

    NewItem = dotVector(RowFirst, Column),
    if
	(NewRow == []) and (TailSecond == []) ->
	    dotArrayRow(NewItem, RowFirst, TailSecond);
	true ->
	    dotArrayRow(NewRow ++ [NewItem], RowFirst, TailSecond)
    end.

matrixNormalForm(Matrix) ->
    [M, N] = shape(Matrix),
    
    if
	M == 1 ->
	    [Arr|_] = Matrix,
	    if
		is_list(Arr) == true ->
		    matrixNormalForm(Arr);
		true ->
		    Matrix
	    end;
	N == 1 ->
	    matrixNormalForm(transpose(Matrix));
	true ->
	    Matrix
    end.

minor(M, N, Matrix) ->
    [Ms, _] = shape(Matrix),
    Sub = subMatrix(M, N, Ms, Matrix),
    det(Sub).

random(M) when is_number(M) ->
    random([], 1, M);

random([1, 1]) ->
    rand:uniform();

random([M, 1]) ->
    random([], 1, M);

random([M, N]) ->
    random([], M, N).

random(Arr, 0, _) ->
    matrixNormalForm(Arr);

random(Arr, M, N) ->
    Row = [rand:uniform() || _ <- lists:seq(1, N)],
    
    random(Arr ++ [Row], M-1, N).

nth(M, N, Matrix) ->
    Row = lists:nth(M, Matrix),
    lists:nth(N, Row).

numers(M, Num) when is_number(M) ->
    numers([], 1, M, Num);

numers([1, 1], Num) ->
    [Num];

numers([M, 1], Num) ->
    numers([], 1, M, Num);

numers([M, N], Num) ->
    numers([], M, N, Num).

numers(Arr, 0, _, _Num) ->
    matrixNormalForm(Arr);

numers(Arr, M, N, Num) ->
    Row = lists:duplicate(N, Num),
    
    numers(Arr ++ [Row], M-1, N, Num).


isVector(Matrix, row) ->
    [M,_] = shape(Matrix),
    
    [First|_] = Matrix,

    case is_list(First) of
	true ->
	    false;
	false ->
	    case M == 1 of
		true ->
		    true;
		false ->
		    false
	    end
    end;

isVector(Matrix, column) ->
    [_,N] = shape(Matrix),
    
    case N == 1 of
	true ->
	    true;
	false ->
	    false
    end.

isVector(Matrix) ->
    [M, N] = shape(Matrix),
    
    if 
	(M == 1) or (N == 1) ->
	    true;
	true -> false
    end.

stringListToMatrix(StringList, Delimiter) ->
    stringListToMatrix([], StringList, Delimiter).

stringListToMatrix(Matrix, [], _Delimiter) ->
    Matrix;

stringListToMatrix(Matrix, StringList, Delimiter) ->
    [First|Tail] = StringList,
    VectorStr = string:split(First, Delimiter, all),
    Vector = [toNumber(X) || X <- VectorStr],
    stringListToMatrix(Matrix ++ [Vector], Tail, Delimiter).

toNumber(Str) ->
    {F,_} = string:to_float(Str),
    
    case F == error of
	true ->
	    {N,_} = string:to_integer(Str),
	    N;
	false ->
	    F
    end.

det(Matrix) ->
    [M, N] = shape(Matrix),
    
    case M == N of
	true ->
	    det(M, Matrix);
	false ->
	    {error, "wrong data"}
    end.

det(2, Matrix) ->
    [[X11, X12], [X21, X22]] = Matrix,
    X11*X22-X12*X21;
det(3, Matrix) ->
    [[X11, X12, X13], [X21, X22, X23], [X31, X32, X33]] = Matrix,
    X11*X22*X33+X12*X23*X31+X13*X21*X32-X13*X22*X31-X12*X21*X33-X11*X23*X32;
det(M, Matrix) ->
    det(0, 1, M, Matrix).

det(Sum, Num, M, _Matrix) when Num > M  ->
    Sum;
det(Sum, Num, M, Matrix) -> 
    Item = nth(Num, 1, Matrix),
    Cof = cofactor(Num, 1, Matrix),
    det(Sum + Item*Cof, Num+1, M, Matrix).

cofactor(M, N, Matrix) ->
    Minor = minor(M, N, Matrix),
    trunc(math:pow(-1, M+N)) * Minor.

subMatrix(M, N, Size, Matrix) ->
    LT = slice(Matrix, [1, 1, M-1, N-1]),
    RT = slice(Matrix, [1, N+1, M-1, Size-N]),
    LB = slice(Matrix, [M+1, 1, Size-M, N-1]),
    RB = slice(Matrix, [M+1, N+1, Size-M, Size-N]),

    join(join(LT, RT), join(LB, RB), vertical).
