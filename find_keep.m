% find_keep.m
tst=1:20;
outtake=[3, 5, 7, 9, 14];
for xi=1:size(outtake,2t)
    tst=tst(tst~=outtake(xi));
end;