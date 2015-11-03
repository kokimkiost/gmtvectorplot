       module vtable
        integer ntable
        real*8,allocatable :: table(:,:)
        real*8 scale
       end module

       program VectorPlot
        use vtable

        integer i,iargc,n
        character*60 infile,str
        real*8 x,y,u,v

        n=iargc()
        if(n.eq.2)then
         call getarg(1,infile)
         call getarg(2,str);read(str,*)scale
!--------------- read format.in
         open(10,file='format.in',status='old',err=90)
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
         open(11,file=infile,status='old',err=92)
 93      read(11,*,end=92)x,y,u,v
         call plotvector(x,y,u,v)
         goto 93
!---------------
 92      continue
!---------------
        else
         write(*,*)'Program: Plot Vector in psxy format'
         write(*,*)'Usage  : vectorplot xyuv.in Scale'
         write(*,*)'  Scale     : Length(inch) of 1 m/s vector'
         write(*,*)'              Vectors will be normalized to 1 m/s'
         write(*,*)'  format.in : vector formats'
         write(*,*)'     (automatically generated)'
         write(*,*)
         write(*,*)' <---------------->Length'
         write(*,*)' <-------->Bar'
         write(*,*)'        <--------->Arrow'
         write(*,*)'         \\            ^'
         write(*,*)'          \ \          |'
         write(*,*)' +---------   \        | ^'
         write(*,*)' |              \      | |'
         write(*,*)' *                >    | |'
         write(*,*)' |              /      | |'
         write(*,*)' +---------   /        | v'
         write(*,*)'          / /          | Tick'
         write(*,*)'         //            v'
         write(*,*)'                       Width'
         write(*,*)' *Mult=numbers of Arrow'
!---------------
         call vectable(0)
         open(10,file='format.in0')
         write(10,*)ntable
         do i=1,ntable
          write(10,'(8F8.3,I8)')(table(i,j),j=1,7),nint(table(i,8))
         enddo
         write(10,*)
         write(10,*)
         write(10,'(A,A)')'      v1      v2  Length     Bar   ',
     &                    'Arrow   Width    Tick    Mult'
         close(10)
        endif
       end program
!=============================
       subroutine vectable(id)
        use vtable
        integer id
        real table0(2,8)
        data table0/
     &      0  ,1  ,  !v1
     &      1  ,2  ,  !v2
     &      1. ,1. ,  !Length
     &      1. ,1. ,  !Bar
     &      0.5,0.5,  !Arrow
     &      0.4,0.4,  !Width
     &      0. ,0. ,  !Tick
     &      1  ,2/    !Mult
!---------------
        select case (id)
!---------------
         case (0)
         ntable=2
         allocate(table(ntable,8))
         table=table0
!---------------
        end select
       end subroutine
!=============================
       subroutine plotvector(x0,y0,u0,v0)
        use vtable
        real*8 x0,y0,u0,v0
        real*8 uv,v1,v2,L,B,A,W,T
        real*8 pi,angle,x,y
        integer M

        pi=4.d0*atan(1.)
        uv=sqrt(u0*u0+v0*v0)
        angle=atan2(v0,u0)
        do n=1,ntable
         v1=table(n,1)
         v2=table(n,2)
         L =table(n,3)*scale
         B =table(n,4)*scale*table(n,3)
         A =table(n,5)*scale*table(n,3)
         W =table(n,6)*scale*table(n,3)
         T =table(n,7)*scale
         M =nint(table(n,8))
         if(uv.gt.v1.and.uv.le.v2)then
          do k=1,M
!--------------- plot arrow
          write(*,'(A)')'>'
          write(*,'(2F20.10)')x0,y0
          x=0.  ; y=T/2
          write(*,'(2F20.10)')
     &    x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
          x=B   ; y=T/2
          write(*,'(2F20.10)')
     &    x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
          x=L-A ; y=W/2
          write(*,'(2F20.10)')
     &    x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
          x=L   ; y=0.
          write(*,'(2F20.10)')
     &    x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
          x=L-A ; y=-W/2
          write(*,'(2F20.10)')
     &    x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
          x=B   ; y=-T/2
          write(*,'(2F20.10)')
     &    x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
          x=0.  ; y=-T/2
          write(*,'(2F20.10)')
     &    x0+x*cos(angle)-y*sin(angle),y0+x*sin(angle)+y*cos(angle)
          write(*,'(2F20.10)')x0,y0
!---------------
          L=L-A/2.
          B=B-A/2.
          enddo
         endif
        enddo
       end subroutine
