SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pItemFat_Sel] 
(
@Num_Fat		VarChar(17)
)
AS
	Select 
		Itf.FatCod, Itf.Num_Proc, Itf.Cd_Tp_Tx, ITf.DC, ITF.Cd_Tp_Moeda, TT.Nome_Tp_Tx,  
		Vlr_Org = 
			Case 
				When DC = 'D' then  dbo.Totext(-Itf.Vlr_Org)
				Else dbo.Totext(Itf.Vlr_Org)
			End, 
		Vlr_OrgS = 
			Case 
				When DC = 'D' then  dbo.ToStext(-Itf.Vlr_Org)
				Else dbo.ToStext(Itf.Vlr_Org)
			End, 

		Vlr_RS = 
			Case 
				When DC = 'D' then  dbo.Totext(-Itf.Vlr_RS)
				Else dbo.Totext(Itf.Vlr_RS)
			End, 

		Vlr_RSS = 
			Case 
				When DC = 'D' then  dbo.ToStext(-Itf.Vlr_RS)
				Else dbo.ToStext(Itf.Vlr_RS)
			End, 


		ITF.Paridade,  TT.Nome_Tp_Tx 
	From 	
		Item_Fat as Itf join Tipo_Taxa as TT on TT.Cd_Tp_Tx = Itf.Cd_Tp_Tx 
	Where
		FatCod = @Num_Fat

GO
