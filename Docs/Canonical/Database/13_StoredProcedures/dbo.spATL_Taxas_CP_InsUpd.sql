SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Taxas_CP
CREATE PROCEDURE [dbo].[spATL_Taxas_CP_InsUpd]
(
	@Cd_Tp_Tx		varchar(3),
	@Modal			varchar(2),
	@Cd_Tp_Carga	varchar(1),
	@Vlr_Taxa		float,
	@Moeda			varchar(3),
	@IVA			char(1)
)

AS

Begin Transaction

	If  exists (select Modal from Taxas_CP where Modal=@Modal AND Cd_Tp_Tx = @Cd_Tp_Tx AND
	Cd_Tp_Carga = @Cd_Tp_Carga)

		Begin
			Update
				Taxas_CP
			Set
				Vlr_Taxa=@Vlr_Taxa,
				Moeda=@Moeda,
				IVA=@IVA
			Where
				Modal=@Modal AND Cd_Tp_Tx = @Cd_Tp_Tx AND Cd_Tp_Carga = @Cd_Tp_Carga
		End
	Else
		Insert
			Taxas_CP(Cd_Tp_Tx,Modal,Cd_Tp_Carga,Vlr_Taxa,Moeda,IVA)

		Values
			(@Cd_Tp_Tx,@Modal,@Cd_Tp_Carga,@Vlr_Taxa,@Moeda,@IVA)
	

Commit Transaction

GO
