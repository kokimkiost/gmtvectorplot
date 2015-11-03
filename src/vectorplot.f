       module vtable
        integer ntable
        real*8,allocatable :: table(:,:)
        real*8 scale
       end module

       program VectorPlot
        use vtable

        integer i,iargc,n
        character*256 infile1,infile2,str
        real*8 x,y,u,v

        n=iargc()
        if(n.eq.3)then
         call getarg(1,infile1)
         call getarg(2,infile2)
         call getarg(3,str);read(str,*)scale
!--------------- read format.in
         open(10,file=infile1,status='old',err=90)
         read(10,*)ntable
         allocate(table(ntable,8))
         do i=1,ntable
          read(10,*)(table(i,j),j=1,8)
         enddo
         close(10)
         goto 91
 90      call vectable(0)
 91      continue
!---------------
         open(11,file=infile2,status='old',err=92)
 93      read(11,*,end=92)x,y,u,v
         call plotvector(x,y,u,v)
         goto 93
!---------------
 92      continue
!---------------
        else
         write(*,*)'Program: Plot Vector in psxy format'
         write(*,*)'Usage  : vectorplot format.in xyuv.in Scale'
         write(*,*)'  Scale     : Length(inch) of 1 m/s vector'
         write(*,*)'              Vectors will be normalized to 1 m/s'
         write(*,*)'  format.in : vector formats'
         write(*,*)'     (automatically generated)'
         write(*,*)
         write(*,*)'Bar:'
         write(*,*)' <-------->BL Bar Length'
         write(*,*)' +---------    ^'
         write(*,*)' |             |'
         write(*,*)' *             |'
         write(*,*)' |             |'
         write(*,*)' +---------    v'
         write(*,*)'     Bar Width BW'
         write(*,*)
         write(*,*)'Arrow:'
         write(*,*)' <---------------->Length'
         write(*,*)'         <-------->AL Arrow Length'
         write(*,*)'         |\            ^'
         write(*,*)'         |  \          |'
         write(*,*)' +-------+    \        |'
         write(*,*)' |              \      |'
         write(*,*)' *                >    |'
         write(*,*)' |              /      |'
         write(*,*)' +-------+    /        |'
         write(*,*)'         |  /          |'
         write(*,*)'         |/            v'
         write(*,*)'           Arrow Width AW'
         write(*,*)
         write(*,*)'AK:1~10 simple arrow'
         write(*,*)'AK:11~20 triangle arrow'
         write(*,*)'AK:21~30 shaped arrow'

!--------------- print sample
         call vectable(0)
         open(10,file='format.sample')
         write(10,*)ntable
         do i=1,ntable
          write(10,'(7F8.3,I8)')(table(i,j),j=1,7),nint(table(i,8))
         enddo
         write(10,*)
         write(10,'(A,A)')'#       v1    v2   Length     ',
     &                    'BL      BW      AL      AW  AK'
         close(10)
         open(11,file='regend.sample')
         write(11,*)'0.1 8.9 2 0 0'
         write(11,*)'0.1 8.7 5 0 2'
         write(11,*)'0.1 8.5 10 0 5'
         write(11,*)'0.1 8.3 15 0 10'
         write(11,*)'0.1 8.1 20 0 15'
         write(11,*)'0.1 7.9 25 0 20'
         write(11,*)'0.1 7.7 30 0 25'
         write(11,*)'0.1 7.5 40 0 30'
         write(11,*)'0.1 7.3 50 0 40'
         write(11,*)'0.1 7.1 60 0 50'
         write(11,*)'0.1 6.9 70 0 60'
         write(11,*)'0.1 6.7 80 0 70'
         write(11,*)'0.1 6.5 100 0 80'
         write(11,*)'0.1 6.3 120 0 100'
         write(11,*)'0.1 6.1 140 0 120'
         write(11,*)'0.1 5.9 160 0 140'
         write(11,*)'0.1 5.7 180 0 160'
         write(11,*)'0.1 5.5 200 0 180'
         write(11,*)'0.1 5.3 250 0 200'
         write(11,*)'0.1 5.1 300 0 250'
         write(11,*)'0.1 4.9 400 0 300'
         close(11)

         write(str,'(A,A)')
     & "vectorplot format.sample regend.sample 0.4 | ",
     & "psxy -R0/10/0/10 -JX12 -W1,0 -m -P > sample.ps"
         call system(str)
         write(str,'(A)')
     & "convert -density 200 -trim sample.ps sample.png"
         call system(str)

        endif
       end program
!=============================
       subroutine vectable(id)
        use vtable
        integer id
        real table0(8,21)
        data table0/
     &   0,    2,  0.500,  0.500,  0.000,  0.200,  0.300,  2,
     &   2,    5,  1.000,  1.000,  0.000,  0.200,  0.300,  1,
     &   5,   10,  1.000,  1.000,  0.000,  0.200,  0.300,  2,
     &  10,   15,  1.000,  1.000,  0.000,  0.200,  0.300,  3,
     &  15,   20,  1.000,  1.000,  0.000,  0.200,  0.300,  4,
     &  20,   25,  1.000,  1.000,  0.000,  0.200,  0.300,  5,
     &  25,   30,  1.000,  1.000,  0.000,  0.200,  0.300,  6,
     &  30,   40,  1.000,  1.000,  0.000,  0.200,  0.300,  8,
     &  40,   50,  1.000,  0.800,  0.000,  0.200,  0.300, 11,
     &  50,   60,  1.000,  0.600,  0.000,  0.200,  0.300, 12,
     &  60,   70,  1.000,  0.400,  0.000,  0.200,  0.300, 13,
     &  70,   80,  1.000,  0.200,  0.000,  0.200,  0.300, 14,
     &  80,  100,  1.000,  0.800,  0.100,  0.200,  0.300, 11,
     & 100,  120,  1.000,  0.500,  0.100,  0.500,  0.300, 21,
     & 120,  140,  1.000,  0.800,  0.100,  0.200,  0.300, 11,
     & 140,  160,  1.000,  0.800,  0.100,  0.200,  0.300, 12,
     & 160,  180,  1.000,  0.800,  0.100,  0.200,  0.300, 13,
     & 180,  200,  1.000,  0.800,  0.100,  0.200,  0.300, 14,
     & 200,  250,  1.000,  0.000,  0.000,  1.000,  0.300,  2,
     & 250,  300,  1.000,  0.000,  0.000,  1.000,  0.300, 11,
     & 300,  400,  1.000,  0.000,  0.300,  1.000,  0.300, 11/
!       v1    v2   Length     BL      BW      AL      AW  AK
!---------------
        select case (id)
!---------------
        case (0)
         ntable=21
         allocate(table(ntable,8))
         do i=1,ntable
         do j=1,8
          table(i,j)=table0(j,i)
         enddo
         enddo
!---------------
        end select
       end subroutine
!=============================
       subroutine plotvector(x0,y0,u0,v0)
        use vtable
        real*8 x0,y0,u0,v0
        real*8 uv,v1,v2,L,BL,BW,AL,AW
        real*8 pi,angle,x,y
        integer AK

        pi=4.d0*atan(1.)
        uv=sqrt(u0*u0+v0*v0)
        angle=atan2(v0,u0)
        do n=1,ntable
         v1=table(n,1)
         v2=table(n,2)
         if(uv.gt.v1.and.uv.le.v2)then

          L =table(n,3)*scale
          BL=table(n,4)*scale
          BW=table(n,5)*scale
          AL=table(n,6)*scale
          AW=table(n,7)*scale
          AK=nint(table(n,8))
!--------------- plot bar
          if(BW.eq.0)then !line
           if(BL.gt.0)then
            write(*,'(A)')'>'
            write(*,'(2F20.10)')x0,y0
            x=BL  ; y=0
            write(*,'(2F20.10)')
     &      x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
           endif
          else !bar 
           write(*,'(A)')'>'
           x=BL  ; y=BW/2
           write(*,'(2F20.10)')
     &     x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
           x=0.  ; y=BW/2
           write(*,'(2F20.10)')
     &     x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
           x=0.  ; y=-BW/2
           write(*,'(2F20.10)')
     &     x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
           x=BL  ; y=-BW/2
           write(*,'(2F20.10)')
     &     x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
          endif
!--------------- plot arrow
          if(AK.ge.1.and.AK.le.10)then !simple arraw
           do k=1,AK
            write(*,'(A)')'>'
            x=L    ; y=0.
            write(*,'(2F20.10)')
     &      x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
            x=L-AL ; y=AW/2
            write(*,'(2F20.10)')
     &      x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
            L=L-AL*mod(k-1,2)
            AW=-AW
           enddo
          elseif(AK.ge.11.and.AK.le.20)then !triangle arraw
           do k=1,AK-10
            write(*,'(A)')'>'
            x=L-AL ; y=BW/2
            write(*,'(2F20.10)')
     &      x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
            x=L-AL ; y=AW/2
            write(*,'(2F20.10)')
     &      x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
            x=L    ; y=0.
            write(*,'(2F20.10)')
     &      x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
            x=L-AL ; y=-AW/2
            write(*,'(2F20.10)')
     &      x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
            x=L-AL ; y=-BW/2
            write(*,'(2F20.10)')
     &      x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
            L=L-AL
           enddo
          elseif(AK.ge.21.and.AK.le.30)then !shape arraw
           do k=1,AK-20
            write(*,'(A)')'>'
            x=BL ; y=BW/2
            write(*,'(2F20.10)')
     &      x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
            x=L-AL ; y=AW/2
            write(*,'(2F20.10)')
     &      x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
            x=L    ; y=0.
            write(*,'(2F20.10)')
     &      x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
            x=L-AL ; y=-AW/2
            write(*,'(2F20.10)')
     &      x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
            x=BL ; y=-BW/2
            write(*,'(2F20.10)')
     &      x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
            L=L-AL
            BL=BL-AL
           enddo
          endif
!---------------
         endif
        enddo
       end subroutine
