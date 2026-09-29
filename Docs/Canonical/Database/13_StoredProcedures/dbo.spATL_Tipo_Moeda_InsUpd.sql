SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Moeda
CREATE PROCEDURE [dbo].[spATL_Tipo_Moeda_InsUpd]
	@Cd_Tp_Moeda			varChar(3),
	@Nome_Tp_Moeda			varChar(30),
	@Cod_Nac_Moeda			VarChar(3),
	@Cod_Int_Moeda			VarChar(2),
	@Cd_Moeda_Ofc			VarChar(5),
	@Cd_Loc_Ofc				VarChar(5),
	@ativo					BIT
AS

Begin Transaction

	If  exists (select Cd_Tp_Moeda from Tipo_Moeda where Cd_Tp_Moeda=@Cd_Tp_Moeda)
	Begin
		Update
			Tipo_Moeda
		Set
			Nome_Tp_Moeda=@Nome_Tp_Moeda,
			Cod_Nac_Moeda = @Cod_Nac_Moeda,
			Cod_Int_Moeda = @Cod_Int_Moeda,
			Cd_Moeda_Ofc = @Cd_Moeda_Ofc,
			Cd_Loc_Ofc = @Cd_Loc_Ofc,
			ativo = @ativo
		Where
			Cd_Tp_Moeda=@Cd_Tp_Moeda
	End
	Else
		Insert
			Tipo_Moeda(Cd_Tp_Moeda,Nome_Tp_Moeda,Cod_Nac_Moeda,Cod_Int_Moeda,Cd_Moeda_Ofc,Cd_Loc_Ofc,ativo)
		Values
			(@Cd_Tp_Moeda,@Nome_Tp_Moeda,@Cod_Nac_Moeda,@Cod_Int_Moeda,@Cd_Moeda_Ofc,@Cd_Loc_Ofc,@ativo)
	

Commit Transaction

GO
