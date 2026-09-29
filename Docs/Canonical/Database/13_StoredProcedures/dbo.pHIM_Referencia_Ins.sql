SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pHIM_Referencia_Ins 
(
@Processo	Char(16),
@Referencia	Char(16)  OUTPUT 
)
AS
	Declare @Seq as Char(3)
	Declare @Mes 	Char(2) 
	If @Processo <> 'JOB'
		Begin 
			Set @Seq = IsNull((Select Max(Right(Num_Proc_HIM,2)) From house_imp_mar Where Num_Proc_MIM = @Processo),0) + 1 
			If Len(@Seq) = 1 
				Set @Seq = '0' + @Seq 
			Set @Referencia = rtrim(@Processo) + @Seq
		End 
	Else
		Begin 
			Set @Mes =  Cast(month(GetDate()) as Char(2))
			If Len(@Mes) = 1 
				Set @Mes = '0' +  Cast(month(GetDate()) as Char(2))
		
			Set @Referencia = IsNull((Select Max(Right(RTrim(JOB_HIM), 3))  From House_Imp_Mar Where Left(JOB_HIM,11) = 'IMJOB' +  Cast(Right(Year(GetDate()),4) as Char(4)) + @Mes),0) + 1
			If Len(@Referencia) = 1 
				Set @Referencia  = '00' + @Referencia 
			If Len(@Referencia) = 2 
				Set @Referencia  = '0' + @Referencia 			
			
			Set @Referencia = 'IMJOB' +  Cast(Right(Year(GetDate()), 4) as Char(4)) +@Mes +  @Referencia
		End
GO
