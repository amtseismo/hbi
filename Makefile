#This is for eqrupt03
OPTFLAGS = -qopenmp -O3 -xCORE-AVX2 -ip -g -traceback
F90=mpiifort
F90FLAGS = $(OPTFLAGS) -fpp
LDFLAGS = -mkl=parallel

LINK=$(F90)

#OBJS= m_const.o TDstressFS.o HACApK_lib.o m_HACApK_calc_entry_ij.o m_HACApK_base.o m_HACApK_solve.o m_HACApK_use.o main_reg.o \

OBJS= m_const.o TDstressFS.o HACApK_lib.o m_HACApK_calc_entry_ij.o m_HACApK_base.o m_HACApK_solve.o m_HACApK_use.o main_new.o \

#OBJS= m_const.o okada.o TDstressFS.o HACApK_lib2.o m_HACApK_calc_entry_ij.o m_HACApK_base3.o m_HACApK_solve3.o m_HACApK_use_skelton.o main_LH.o \

TARGET=hbiem
#TARGET=lhbiem

.SUFFIXES: .o .f90

$(TARGET): $(OBJS)
			$(LINK) -o $@ $(OBJS) $(LDFLAGS)

.f90.o: *.f90
			$(F90) -c $< $(F90FLAGS)
clean:
	rm -f *.o *.mod $(TARGET)

rmod:
	rm -f m_*.o *.mod
