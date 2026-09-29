SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTarAer_Sel
(
@Origem		Varchar(30)='', 
@Destino		VarChar(30)='', 
@Via			VarChar(30)='', 
@Cia_Aerea		VarChar(30)='',
@TptDescricao		varchar(20)='',
@TAEID		int = 0 
)
AS
	If @TAEID = 0 
		Begin 
			Select
				TAE.*, 
				Org.Nome_Local Origem, 
				Dst.Nome_Local Destino, 
				Via.Nome_Local Via, 
				Cia.Nome_Cia_Aer as Cia_Aerea,
				TM.Nome_Tp_Moeda,
				TT.TptDescricao 
				
			From 
				Tar_Aer TAE Join  Localidade Org on Org.Cd_Local = TAE.TAECdOrg
				Join Localidade Dst on Dst.Cd_Local = TAE.TAECdDst 
				Join Localidade Via on Via.Cd_Local = TAE.TAECdVia  
				Join Cia_Aerea Cia on Cia.Cd_Cia_Aer = TAE.Cd_Cia_Aer 
				Join Tipo_Moeda TM on TM.Cd_Tp_Moeda = TAE.Cd_Tp_Moeda 
				Join Tipo_Tarifario TT on TT.TptID = TAE.tptID
			Where 
				Org.Nome_Local = @Origem and
				Dst.Nome_Local = @Destino and 
				Via.Nome_Local = @Via and 
				Cia.Nome_Cia_Aer = @Cia_Aerea and 
				TT.TptDescricao = @TptDescricao
		End 
	Else
		Begin 
			Select
				TAE.*,
				Org.Nome_Local Origem, 
				Dst.Nome_Local Destino, 
				Via.Nome_Local Via, 
				Cia.Nome_Cia_Aer as Cia_Aerea,
				TM.Nome_Tp_Moeda,
				TT.TptDescricao 
				
			From 
				Tar_Aer TAE Join  Localidade Org on Org.Cd_Local = TAE.TAECdOrg
				Join Localidade Dst on Dst.Cd_Local = TAE.TAECdDst 
				Join Localidade Via on Via.Cd_Local = TAE.TAECdVia  
				Join Cia_Aerea Cia on Cia.Cd_Cia_Aer = TAE.Cd_Cia_Aer 
				Join Tipo_Moeda TM on TM.Cd_Tp_Moeda = TAE.Cd_Tp_Moeda 
				Join Tipo_Tarifario TT on TT.TptID = TAE.tptID
			Where 

				TAE.TAEID = @TAEID
		End
GO
