program main
  !make meshes for "2dn" of hbi
  implicit none
  integer::i,NCELLg,nm,file_size,n,count,j,jmax,seedsize
  real(8)::xel(100000),xer(100000),yel(100000),yer(100000)
  real(8)::xr(160001),yr(160001)
  real(8),parameter::pi=4.d0*atan(1.d0)
  real(8),allocatable::data(:),ang(:),xg(:),yg(:)
  integer,allocatable::ns(:)
  real(8)::ds,r,amp,wid,xc,yc,rr,yf,angle
  character(128)::geofile,type
  integer,allocatable::seed(:)

  call random_seed(size=seedsize)
  allocate(seed(seedsize))
  do i = 1, seedsize
    call system_clock(count=seed(i))
  end do
  call random_seed(put=seed(:))

  xel=0d0;xer=0d0;yel=0d0;yer=0d0
  type='multi'

  select case(type)
  case('two')
   ncellg=2400
   ds=0.0025d0
   angle=-0d0/180*pi
   do i=1,2000
     xel(i)=cos(angle)*ds*(i-1)
     xer(i)=cos(angle)*ds*i
     yel(i)=sin(angle)*ds*(i-1)
     yer(i)=sin(angle)*ds*i
     write(*,*) xel(i),yel(i)
   end do
   angle=-75d0/180*pi
   do i=1,400
   xel(2000+i)=cos(angle)*ds*(i-1)+3.0
     xer(2000+i)=cos(angle)*ds*i+3.0
     yel(2000+i)=sin(angle)*ds*(i-1)-0.005d0
     yer(2000+i)=sin(angle)*ds*i-0.005d0
     write(*,*) xel(2000+i),yel(2000+i)
   end do

 case('bend')
   ncellg=2400
   ds=0.0025d0
   angle=10d0/180d0*pi
   xel(1)=0d0
   yel(1)=0d0
   do i=1,1000
     xel(i)=xer(i-1)
     xer(i)=xel(i)+ds
     yel(i)=yer(i-1)
     yer(i)=yel(i)
     write(*,*) xel(i),yel(i)
   end do
   do i=1001,1400
     xel(i)=xer(i-1)
     xer(i)=xel(i)+cos(angle)*ds
     yel(i)=yer(i-1)
     yer(i)=yel(i)+sin(angle)*ds
     write(*,*) xel(i),yel(i)
   end do
   do i=1401,2400
     xel(i)=xer(i-1)
     xer(i)=xel(i)+ds
     yel(i)=yer(i-1)
     yer(i)=yel(i)
     write(*,*) xel(i),yel(i)
   end do

 case('curve')
   geofile='spline'
   ds=0.0025
   ncellg=2000
   open(20,file=geofile)
   do i=0,ncellg
   read(20,*) yr(i)
   end do
 do i=1,ncellg
   xel(i)=ds*(i-1)
   xer(i)=ds*i
   yel(i)=yr(i)
   !call random_number(r)
   yer(i)=yr(i+1)
   write(*,*) xel(i),yel(i)
 end do
  case('flat')
   ncellg=2000
   ds=0.0025d0
   angle=-70d0/180d0*pi
   do i=1,NCELLg
     xel(i)=cos(angle)*ds*(i-1)
     xer(i)=cos(angle)*ds*i
     yel(i)=sin(angle)*ds*(i-1)
     yer(i)=sin(angle)*ds*i
     write(*,*) xel(i),yel(i)
   end do

  case('multi')
  !parameters
  nm=40000
  jmax=150
  allocate(ns(jmax),ang(jmax),xg(jmax),yg(jmax))
  ds=0.0025d0
  amp=0.06
  !amp=0.001
  wid=5.d-2

  !length
  !ns=(/300,300,300,300,300,200,200,200,200,200/)
  !ns=150
  !power law
  open(33,file='ns.txt')
  do j=1,jmax
    read(33,*) r
    ns(j)=int(r)
  !call random_number(r)
  !  ns(j)=120d0*2d0**(3*r)
  end do
  !call random_number(xc)
  !call random_number(yc)
  !yc=(yc-0.5d0)*wid
  !write(*,*) yc
  !xc=(/0.5,0.2,0.8,0.3,0.7/)
  !yc=(/-0.06,0.0,0.03,-0.1,-0.02/)
  !ang=(/0,10,-10,10,-10/)
  call random_number(ang)
  ang=(ang-0.5d0)*60d0
  !ang=0d0
  ang=ang/180*pi
  !xc=(xc-0.1d0)*nm*ds*1.2d0
  !yc=yc*nm*ds
  !read rough dataset
  geofile='160001seed17.curve'
  open(20,file=geofile,access='stream')
  inquire(20, size=file_size)
  n=file_size/8
  allocate(data(n))
  read(20) data
  close(20)
  xr(1:n/4)=data(1:n/4)
  yr(1:n/4)=data(n/4+1:n/2)
  !write(*,*) xr(1:n/4),yr(1:n/4)
    do i=1,nm
      xel(i)=ds*(i-1)
      xer(i)=ds*i
      yel(i)=amp*yr(i)-i*amp*yr(nm)/nm!-!+r*0.0001d0
      !call random_number(r)
      yer(i)=amp*yr(i+1)-(i+1)*amp*yr(nm)/nm!+r*0.0001d0
    end do
    do i=1,nm
      yel(i)=yel(i)-sum(yel(1:nm))/nm
      yer(i)=yer(i)-sum(yel(1:nm))/nm
      write(*,*) xel(i),yel(i)
    end do
    write(*,*)
    count=nm
    do j=1,jmax
      100 call random_number(xc)
      call random_number(yc)
      xc=0.5d0*nm*ds+(xc-0.5d0)*nm*ds*1.1d0
      yf=yel(int(xc/ds))
      if(xc.le.0) yf=yel(1)
      if(xc.gt.100) yf=yel(nm)
      yc=wid*(yc-0.5d0)*nm*ds+yf

      !check overlap
      do i=1,nm
        rr=(xc-xel(i))**2+(yc-yel(i))**2
        if(rr.lt.(ns(j)*ds/2)**2) then
          go to 100
        end if
      end do
      do i=1,j-1
        rr=(xc-xg(i))**2+(yc-yg(i))**2
        if(rr.lt.((ns(i)+ns(j))*ds/2)**2)then
          go to 100
        end if
      end do

      do i=1,ns(j)
        xel(count+i)=xc+cos(ang(j))*ds*(i-1-ns(j)/2)
        xer(count+i)=xc+cos(ang(j))*ds*(i-ns(j)/2)
        yel(count+i)=yc+sin(ang(j))*ds*(i-1-ns(j)/2)!+amp*(yr(count+i)-yr(count))!+r*0.0001d0
        !call random_number(r)
        yer(count+i)=yc+sin(ang(j))*ds*(i-ns(j)/2)!+amp*(yr(count+i+1)-yr(count))!+r*0.0001d0
        write(*,*) xel(count+i),yel(count+i)
      end do
      xg(j)=xc
      yg(j)=yc
      write(*,*)
      count=count+ns(j)
    end do
      NCELLg=count
  end select
  !output
  geofile='geotmp'
  !write(*,*) "No. of elements=", NCELLg
  open(20,file=geofile,access='stream')
  write(20) xel(1:NCELLg),xer(1:NCELLg),yel(1:NCELLg),yer(1:NCELLg)
  close(20)
  stop
end program
