SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pCotacao_Ins 
(
@Cd_Pes			varchar(10),
@Cd_Usuario			varchar(6),
@Cd_Org_Cot			varchar(3),
@Cd_Dst_Cot			varchar(3),
@Modal_Cot			char(2),
@Cd_Tp_Prod			varchar(3),
@Cd_Tp_Oper			varchar(3),
@Ck_Perigosa			bit,
@Ck_Perecivel			bit,
@Dados_Adic_Cot		varchar(300),
@Det_Pick_Up_Cot		varchar(300),
@Obs_Cot			varchar(300),
@Num_Cot			varchar(10) = '' OUTPUT 
)
AS

	Begin Transaction 
	Declare @Mes 	Char(2) 
	Set @Mes =  Cast(month(GetDate()) as Char(2))
	If Len(@Mes) = 1 
		Set @Mes = '0' +  Cast(month(GetDate()) as Char(2))
	Set @Num_Cot = IsNull((Select Max(Right(Num_Cot, 4))  From Cotacao Where Left(Num_Cot, 6) = 'CS' + Cast(Right(Year(GetDate()),2) as Char(2)) + @Mes),0) + 1 			
	If Len(@Num_Cot) = 1 
		Set @Num_Cot  = '000' + @Num_Cot 
	If Len(@Num_Cot) = 2 
		Set @Num_Cot  = '00' + @Num_Cot 			
	If Len(@Num_Cot) = 2 
		Set @Num_Cot  = '0' + @Num_Cot 						

	Set @Num_Cot = 'CS' +  Cast(Right(year(GetDate()),2) as Char(2)) +@Mes +  @Num_Cot
	
	Insert Into Cotacao 
		(Num_Cot, Cd_Pes, Cd_Usuario, Dt_Cot, Cd_Org_Cot, Cd_Dst_Cot, Modal_Cot, Cd_Tp_Prod, Cd_Tp_Oper, Ck_Perigosa, Ck_Perecivel, Dados_Adic_Cot, Det_Pick_Up_Cot, Obs_Cot)
	Values
		(@Num_Cot, @Cd_Pes, @Cd_Usuario, GetDate(), @Cd_Org_Cot, @Cd_Dst_Cot, @Modal_Cot, @Cd_Tp_Prod, @Cd_Tp_Oper, @Ck_Perigosa, @Ck_Perecivel, @Dados_Adic_Cot, @Det_Pick_Up_Cot, @Obs_Cot)

	IF @@RowCount = 1 
		Begin 
			Commit Transaction 
			Return 1 
		End 
	Else
		Begin 
			RollBack Transaction 
			Return -1
		End

GO
