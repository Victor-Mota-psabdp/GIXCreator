SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTarMar_Sel
(
@Origem		Varchar(30)='', 
@Destino		VarChar(30)='', 
@Via			VarChar(30)='', 
@Armador		VarChar(30)='',
@TptDescricao		varchar(50)='', 
@TAMID		int = 0 
)
AS
	If @TAMID = 0 
		Begin 
			Select
				TAM.*, 
				Org.Nome_Local Origem, 
				Dst.Nome_Local Destino, 
				Via.Nome_Local Via, 
				Arm.Nome_Armador as Armador,
				TM.Nome_Tp_Moeda, 
				TT.TptDescricao 
				
			From 
				Tar_Mar TAM Join  Localidade Org on Org.Cd_Local = TAM.TAMCdOrg
				Join Localidade Dst on Dst.Cd_Local = TAM.TAMCdDst 
				Join Localidade Via on Via.Cd_Local = TAM.TAMCdVia  
				Join Armador Arm on Arm.Cd_Armador = TAM.Cd_Armador
				Join Tipo_Moeda TM on TM.Cd_Tp_Moeda = TAM.Cd_Tp_Moeda 
				Join Tipo_Tarifario TT on TT.TptID = TAM.TptID
			Where 
				Org.Nome_Local = @Origem and
				Dst.Nome_Local = @Destino and 
				Via.Nome_Local = @Via and 
				Arm.Nome_Armador = @Armador and 
				TT.TptDescricao = @TptDescricao 
		End 
	Else
		Begin 
			Select
				TAM.*,
				Org.Nome_Local Origem, 
				Dst.Nome_Local Destino, 
				Via.Nome_Local Via, 
				Arm.Nome_Armador as Armador,
				TM.Nome_Tp_Moeda, 
				TT.TptDescricao 
				
			From 
				Tar_Mar TAM Join  Localidade Org on Org.Cd_Local = TAM.TAMCdOrg
				Join Localidade Dst on Dst.Cd_Local = TAM.TAMCdDst 
				Join Localidade Via on Via.Cd_Local = TAM.TAMCdVia  
				Join Armador Arm on Arm.Cd_Armador = TAM.Cd_Armador
				Join Tipo_Moeda TM on TM.Cd_Tp_Moeda = TAM.Cd_Tp_Moeda 
				Join Tipo_Tarifario TT on TT.TptID = TAM.TptID 
			Where 

				TAM.TAMID = @TAMID
		End

GO
