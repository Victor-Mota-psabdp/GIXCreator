SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spMoeda_InsUpd 'ZAR','SOUTH AFRICAN RAND','785','01', ''

--select * from aux_moeda
--update tipo_moeda set cd_moeda_ofc = '00040'
--where cd_tp_moeda = '0'

CREATE PROCEDURE [dbo].[spMoeda_InsUpd]

			@Cd_Tp_Moeda	char(3),
			@Nome_Tp_Moeda	varchar(30),
			@Cod_Nac_Moeda	varchar(3),
			@Cod_Int_Moeda	varchar(2),
			@Moeda_Ofc		varchar(50)

AS


Begin Transaction

	Declare @Cd_Moeda_Ofc varchar (5)

	set @Cd_moeda_Ofc = (select cd_moeda_Ofc from aux_moeda where nome_moeda = @moeda_ofc)

	If  exists (select cd_tp_moeda from tipo_moeda where cd_tp_moeda=@Cd_Tp_Moeda)
	Begin
		Update
			Tipo_Moeda
		Set
			Nome_Tp_Moeda=@Nome_Tp_Moeda,
			Cod_Nac_Moeda=@Cod_Nac_Moeda,
			Cod_Int_Moeda= @Cod_Int_Moeda,
			Cd_Moeda_Ofc = @Cd_Moeda_Ofc
		Where
			cd_Tp_moeda=@Cd_Tp_Moeda
	End
	Else
		Insert
			Tipo_moeda(
				Cd_Tp_Moeda,
				Nome_Tp_Moeda,
				Cod_Nac_Moeda,
				Cod_Int_Moeda,
				Cd_Moeda_Ofc
				)
		Values
			(
			@Cd_Tp_Moeda,	
			@Nome_Tp_Moeda,	
			@Cod_Nac_Moeda,	
			@Cod_Int_Moeda,
			@Cd_Moeda_Ofc	
		)
	

Commit Transaction




GO
