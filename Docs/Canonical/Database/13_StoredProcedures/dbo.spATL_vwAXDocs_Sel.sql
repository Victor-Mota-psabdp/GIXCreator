SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_vwAXDocs_Sel]--'EAATL201902022BR','','','A'
(
	@Num_Proc	VarChar(16),
	@Cd_tp_tx	varchar(3),
	@DC			varchar(1),
	@Tipo		char(1)
)

AS

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		SELECT
			'Saved'								[Status],
			CC.Num_Proc							[JOB],	
			CC.cd_tp_tx_Atl						[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC								[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],				
			NumeroInternoAX						[NumeroInternoAX],
			id_Ax								[Id_Ax],
			Tax_Group							[Tax_Group]
		FROM vwAXDocs CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx_Atl = TT.cd_tp_tx		
			left join Tipo_dc		TDC with(nolock) on CC.DC = TDC.Cd_Tp_DC
		WHERE 
			CC.Num_Proc =@Num_Proc  and 
			CC.cd_tp_tx_Atl = @Cd_Tp_Tx and 
			CC.DC = @DC
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			'Saved'								[Status],
			CC.Num_Proc							[JOB],	
			CC.cd_tp_tx_Atl						[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC								[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],				
			NumeroInternoAX						[NumeroInternoAX],
			id_Ax								[Id_Ax],
			Tax_Group							[Tax_Group]
		FROM vwAXDocs CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx_Atl = TT.cd_tp_tx		
			left join Tipo_dc		TDC with(nolock) on CC.DC = TDC.Cd_Tp_DC
		WHERE 
			CC.Num_Proc =@Num_Proc  and 
			CC.cd_tp_tx_Atl = @Cd_Tp_Tx and 
			CC.DC = @DC
	End




GO
