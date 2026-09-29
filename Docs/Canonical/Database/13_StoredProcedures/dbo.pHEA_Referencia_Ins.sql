SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pHEA_Referencia_Ins 
(
@Processo	Char(16),
@Referencia	Char(16)  OUTPUT 
)
AS
	Declare @Seq as Char(3)
	Declare @Mes 	Char(2) 
	Declare @Cont   as int 
	Declare @Valida as Int 
	If @Processo <> 'JOB'
		Begin 
			Set @Seq = IsNull((Select Max(Right(Num_Proc_HEA,2)) From House_Exp_Aer Where Num_Proc_MEA = @Processo),0) + 1 
			If Len(@Seq) = 1 
				Set @Seq = '0' + @Seq 
			Set @Referencia = rtrim(@Processo) + @Seq
		End 
	Else
		Begin 
			Set @Mes =  Cast(month(GetDate()) as Char(2))
			If Len(@Mes) = 1 
				Set @Mes = '0' +  Cast(month(GetDate()) as Char(2))
		
			Set @Referencia = IsNull((Select Max(Right(Rtrim(JOB_HEA), 3))  From House_Exp_Aer Where Left(JOB_HEA,11) = 'EAJOB' +  Cast(Right(Year(GetDate()),4) as Char(4)) + @Mes),0) + 1
			Set @Cont = @Referencia 
			Set @Valida = 0 
			while @Valida = 0 
				Begin 
					If Len(@Referencia) = 1 
						Set @Referencia  = '00' + @Referencia 
					If Len(@Referencia) = 2 
						Set @Referencia  = '0' + @Referencia 			
					
					Set @Referencia = 'EAJOB' +  Cast(Right(Year(GetDate()), 4) as Char(4)) +@Mes +  @Referencia
					If Not Exists(Select Num_Proc_HEA  From Job_Exp_Aer Where Num_Proc_HEA = @Referencia)
						Begin 
							Set @Valida = 1 
						End 
					Else
						Begin 
							Set @Cont = @Cont + 1 
							Set @Referencia = @Cont
						End 

				End 


		End
GO
