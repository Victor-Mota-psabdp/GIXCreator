SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pHIA_Referencia_Ins 
(
@Processo	VarChar(16),
@Referencia	VarChar(16)  OUTPUT 
)
AS
	Declare @Seq as Char(3)
	Declare @Mes 	Char(2) 
	Declare @Referencia2	VarChar(16)  
	If @Processo <> 'JOB'
		Begin 
			Set @Seq = IsNull((Select Max(Right(Num_Proc_HIA,2)) From House_Imp_Aer Where Num_Proc_MIA = @Processo),0) + 1 
			If Len(@Seq) = 1 
				Set @Seq = '0' + @Seq 
			Set @Referencia = rtrim(@Processo) + @Seq
		End 
	Else
		Begin 
			Set @Mes =  Cast(month(GetDate()) as Char(2))
			If Len(@Mes) = 1 
				Set @Mes = '0' +  Cast(month(GetDate()) as Char(2))
		
			Set @Referencia = IsNull((Select Max(Right(RTrim(JOB_HIA), 3))  From House_Imp_Aer Where Left(JOB_HIA,11) = 'IAJOB' +  Cast(Right(Year(GetDate()),4) as Char(4)) + @Mes),0) + 1
			Set @Referencia2 = IsNull((Select Max(Right(RTrim(Num_Proc_HIA), 3))  From Job_Imp_Aer Where Left(Num_Proc_HIA,11) = 'IAJOB' +  Cast(Right(Year(GetDate()),4) as Char(4)) + @Mes),0) + 1

			If Cast(@Referencia2 as Int) > Cast(@Referencia as Int)
				Set @Referencia = @Referencia2

			If Len(@Referencia) = 1 
				Set @Referencia  = '00' + @Referencia 
			If Len(@Referencia) = 2 
				Set @Referencia  = '0' + @Referencia 			
			
			Set @Referencia = 'IAJOB' +  Cast(Right(Year(GetDate()), 4) as Char(4)) +@Mes +  @Referencia

		End
GO
