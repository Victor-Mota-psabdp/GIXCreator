SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pCotacao_Upd
(
@Num_Cot			varchar(10), 
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
@Obs_Cot			varchar(300)
)
AS

	Update 
		Cotacao
	Set 
		Cd_Pes=@Cd_Pes,
		Cd_Usuario=@Cd_Usuario,
		Cd_Org_Cot=@Cd_Org_Cot,
		Cd_Dst_Cot=@Cd_Dst_Cot,
		Modal_Cot=@Modal_Cot,
		Cd_Tp_Prod=@Cd_Tp_Prod,
		Cd_Tp_Oper=@Cd_Tp_Oper,
		Ck_Perigosa=@Ck_Perigosa,
		Ck_Perecivel=@Ck_Perecivel,
		Dados_Adic_Cot=@Dados_Adic_Cot,
		Det_Pick_Up_Cot=@Det_Pick_Up_Cot,
		Obs_Cot=@Obs_Cot
	Where
		Num_Cot = @Num_Cot

	Return @@RowCount

GO
