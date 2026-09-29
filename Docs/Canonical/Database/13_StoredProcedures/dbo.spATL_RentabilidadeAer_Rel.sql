SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_RentabilidadeAer_Rel] --spATL_RentabilidadeAer_Rel '07-01-2013','07-31-2013','Air Export'
 

		@DataInicial Datetime,
		@DataFinal	Datetime,
		@Modal		Varchar(30)
		
AS
	Declare @Num_Proc	Varchar(16)
	Declare @Num_Master	Varchar(14)
/*

	Report solicitado por Joao Djalma 
	Report desenvolvido por Anderson Oliveira - 14/08/2013
	Report Alterado por Rafael Lindenberg - 13/11/2014 (Conversação da taxa de Real para Dolar)
*/



if @Modal='Air Import'
	Begin
		Declare @Temp Table
			(
				[Job #]						Varchar(16), ---OK
				[Job Date]					Datetime, ----OK
				[Consol Ref.]				Varchar(14), ---OK
				[Customer Acc]				Varchar(50), --OK
				[Shipper Name]				Varchar(60), ---OK
				[Customer Acc 2]			Varchar(50),  --OK
				[Consignee Name]			Varchar(60), --OK
				[HAWB]						Varchar(30), --OK
				[MAWB]						Varchar(30), --OK
				[Origin]					Varchar(35), --OK
				[Destination]				Varchar(35), --OK
				[PPD]						Char(1),
				[COL]						Char(1),
				[ETD]						Datetime, --OK
				[ATD]						Datetime, --OK
				[ETA]						Datetime, --OK
				[ATA]						Datetime, --OK
				[G.Weight - KG]				Decimal(10,2), --OK
				[C. Weight - KG]			Decimal(10,2), --OK
				[V. Weight - KG]			Decimal(10,2),
				[M3]						Decimal(10,2), --OK
				[HAWB Currency]				Varchar(3), --OK
				[Exchange USD]				float,
				[AF Income]					Decimal(10,2),
				[AF Cost]					Decimal(10,2),
				[AF Profit Share BR]		Decimal(10,2),
				[EXW Income]				Decimal(10,2),
				[EXW Margin]				Decimal(10,2),
				[Deconsolidation]			Decimal(10,2),
				[Collect Fee]				Decimal(10,2),
				[Delivery Doc Fee Income]	Decimal(10,2),
				[Delivery Doc Fee Cost]		Decimal(10,2),
				[Delivery Doc Fee Profit]	Decimal(10,2),
				[DGR Fee]					Decimal(10,2),
				[TOTAL GP]					Decimal(10,2)
				
						
			)
	
			Insert @Temp (
							[Job #],
							[Job Date],
							[Consol Ref.],
							[Shipper Name],
							[Consignee Name],
							[HAWB],
							[MAWB],
							[Origin],
							[Destination],
							[ETD],
							[ATD],
							[ETA],
							[ATA],
							[G.Weight - KG],
							[C. Weight - KG],
							[M3],
							[HAWB Currency],
							[Customer Acc],
							[Customer Acc 2],
							[PPD],
							[COL]
						
						)
			
			
			Select 
					Num_Proc_Hia Job,
					convert(Datetime,dt_emis_hia,105) ,
					Num_Proc_MIA,
					SH.Nome_Raz_Soc,
					CS.Nome_Raz_Soc,
					HAWB_HIA,
					MAWB_HIA,
					Org.Nome_Local,
					Dst.Nome_local,
					ETD_LIA,
					ATD_LIA,
					ETA_LIA,
					ATA_LIA,
					Peso_bruto_hia,
					Peso_Cubado_lia,
					Vol_Tot_HIA,
					HOU.cd_tp_Moeda,
					SH.Cd_Pes,
					CS.cd_Pes,
					Case
						when TP_Frete_HIA='P' then 'X'
						else ''
					End,
					
					Case
						when TP_Frete_HIA='C' then 'X'
						else ''
					End
						
		
					
			from 
					house_imp_aer hou with(nolock)
					Join Pessoa SH with(nolock) on SH.cd_pes=cd_export_hia
					Join Pessoa CS with(nolock) on CS.cd_pes=cd_consig_hia
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_hia
					Join Localidade Dst with (nolock) on DST.cd_local=cd_dst_hia
					Join LLP_Imp_Aer LLP with (nolock) on Num_ProC_lia=hou.num_proc_hia
			where 
				convert(Datetime,dt_emis_hia,105) between @DataInicial and @DataFinal and num_proc_mia <> 'JOB'
			Select * from @Temp
		End

if @Modal='Air Export'
	Begin
		Declare @TempExp Table
			(
				[Job #]						Varchar(16), ---OK
				[Job Date]					Datetime, ----OK
				[Consol Ref.]				Varchar(14), ---OK
				[Customer Acc]				Varchar(50), --OK
				[Shipper Name]				Varchar(60), ---OK
				[Customer Acc 2]			Varchar(50),  --OK
				[Consignee Name]			Varchar(60), --OK
				[HAWB]						Varchar(30), --OK
				[MAWB]						Varchar(30), --OK
				[Origin]					Varchar(35), --OK
				[Destination]				Varchar(35), --OK
				[PPD]						Char(1),
				[COL]						Char(1),
				[ETD]						Datetime, --OK
				[ATD]						Datetime, --OK
				[ETA]						Datetime, --OK
				[ATA]						Datetime, --OK
				[G.Weight - KG]				Decimal(10,2), --OK
				[C. Weight - KG]			Decimal(10,2), --OK
				[V. Weight - KG]			Decimal(10,2),
				[M3]						Decimal(10,2), --OK
				[AF Income]					Decimal(10,2),
				[AF Net/Net]				Decimal(10,2),
				[AF Buying Destination]		Decimal(10,2),
				[AF Profit]					Decimal(10,2),
				[AF P/ Share Destino]		Decimal(10,2),
				[PUA Income]				Decimal(10,2), --OK
				[PUA Cost]					Decimal(10,2), --OK
				[PUA Profit]				Decimal(10,2),
				[CHA]						Decimal(10,2),
				[AWA]						Decimal(10,2),
				[SOA Income]				Decimal(10,2), --OK
				[SOA Cost]					Decimal(10,2),  ---OK
				[SOA Profit]				Decimal(10,2),
				[AWC Income]				Decimal(10,2), --OK
				[AWC Cost]					Decimal(10,2), --OK
				[AWC Profit]				Decimal(10,2),
				[DGR Fee]					Decimal(10,2),
				[Total Gross Profit]		Decimal(10,2)
				
						
			)
	
			Insert @TempExp (
							[Job #],
							[Job Date],
							[Consol Ref.],
							[Shipper Name],
							[Consignee Name],
							[HAWB],
							[MAWB],
							[Origin],
							[Destination],
							[ETD],
							[ATD],
							[ETA],
							[ATA],
							[G.Weight - KG],
							[C. Weight - KG],
							[M3],
						
							[Customer Acc],
							[Customer Acc 2],
							[PPD],
							[COL]
						
						)
			
			
			Select 
					Num_Proc_HEA Job,
					convert(Datetime,dt_emis_hEA,105) ,
					Num_Proc_MEA,
					SH.Nome_Raz_Soc,
					CS.Nome_Raz_Soc,
					HAWB_HEA,
					MAWB_HEA,
					Org.Nome_Local,
					Dst.Nome_local,
					ETD_LEA,
					ATD_LEA,
					ETA_LEA,
					ATA_LEA,
					Peso_bruto_hEA,
					Peso_Cubado_lEA,
					Vol_Tot_HEA,
					SH.Cd_Pes,
					CS.cd_Pes,
					Case
						when TP_Frete_HEA='P' then 'X'
						else ''
					End,
					
					Case
						when TP_Frete_HEA='C' then 'X'
						else ''
					End
						
		
					
			from 
					house_exp_aer hou with(nolock)
					Join Pessoa SH with(nolock) on SH.cd_pes=cd_export_hea
					Join Pessoa CS with(nolock) on CS.cd_pes=cd_consig_hea
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_hea
					Join Localidade Dst with (nolock) on DST.cd_local=cd_dst_hea
					Join LLP_Exp_Aer LLP with (nolock) on Num_ProC_lea=hou.num_proc_hea
			where 
				convert(Datetime,dt_emis_hea,105) between @DataInicial and @DataFinal and num_proc_mea <> 'JOB'
			Declare cTemp cursor for
				Select [Job #],[Consol Ref.] From @TempExp
				Open cTemp
				Fetch Next From cTemp into @Num_proc,@Num_Master
			While @@FETCH_STATUS = 0
				begin
					Update @TempExp
						Set							
							[PUA Income]=			(select isnull(sum(vlr_org_hea),0) from cta_cte_hou_exp_aer cta Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx where num_proc_hea=@num_proc and cd_tp_tx_ofc='PUA' and dc_hea='C'),
							[PUA Cost]=				(select isnull(sum((Case when Cd_Tp_Moeda = 'REL' then  vlr_org_hea / dbo.VerParidade(CONVERT(varchar,Dt_Ins_hea,103),'USD','OFC') else vlr_org_hea end)),0) from cta_cte_hou_exp_aer cta Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx where num_proc_hea=@num_proc and cd_tp_tx_ofc='PUA' and dc_hea='D'),
							[SOA Income]=			(select isnull(sum(vlr_org_hea),0) from cta_cte_hou_exp_aer cta Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx where num_proc_hea=@num_proc and cd_tp_tx_ofc='SOA' and dc_hea='C'),
							[SOA Cost]=				(select isnull(sum((Case when Cd_Tp_Moeda = 'REL' then  vlr_org_hea / dbo.VerParidade(CONVERT(varchar,Dt_Ins_hea,103),'USD','OFC') else vlr_org_hea end)),0) from cta_cte_hou_exp_aer cta Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx where num_proc_hea=@num_proc and cd_tp_tx_ofc='SOA' and dc_hea='D'),
							[AWC Income]=			(select isnull(sum(vlr_org_hea),0) from cta_cte_hou_exp_aer cta Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx where num_proc_hea=@num_proc and cd_tp_tx_ofc='AWC' and dc_hea='C'),
							[AWC Cost]=				(select isnull(sum(vlr_org_hea),0) from cta_cte_hou_exp_aer cta Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx where num_proc_hea=@num_proc and cd_tp_tx_ofc='AWC' and dc_hea='D'),
							[AWA]=					(select isnull(sum(vlr_org_hea),0) from cta_cte_hou_exp_aer cta Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx where num_proc_hea=@num_proc and cd_tp_tx_ofc='AWA' and dc_hea='C'),
							[DGR Fee]=				(select isnull(sum(vlr_org_hea),0) from cta_cte_hou_exp_aer cta Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx where num_proc_hea=@num_proc and cd_tp_tx_ofc='DGR' and dc_hea='C'),
							[AF Income]=			(select isnull(sum(vlr_org_hea),0) from cta_cte_hou_exp_aer cta Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx where num_proc_hea=@num_proc and cd_tp_tx_ofc='FRT' and dc_hea='C'),
							[CHA]=					(select isnull(sum(vlr_org_hea),0) from cta_cte_hou_exp_aer cta Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx where num_proc_hea=@num_proc and cd_tp_tx_ofc='CHA' and dc_hea='C'),
							[AF Buying Destination]=(select isnull(sum(vlr_org_mea),0) from cta_cte_mas_exp_aer cta Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx where num_proc_mea=@Num_Master and cd_tp_tx_ofc='FRT' and dc_mea='D') +(select isnull(sum(vlr_org_hea),0) from cta_cte_hou_exp_aer cta Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx where num_proc_hea=@num_proc and cd_tp_tx_ofc='FRT' and dc_hea='D')
					Where
							[Job #]=@num_proc			

					Update @TempExp
							set [AF Net/Net]=[AF Buying Destination]-(select isnull(sum(vlr_org_mea),0) from cta_cte_mas_exp_aer cta Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_Tx where num_proc_mea=@num_master and cd_tp_tx_ofc='IAT' and dc_mea='C')
					Where [Job #]=@num_proc			
					
				
					
					Fetch Next From cTemp into @Num_proc,@Num_Master
				
				End
				deallocate cTemp
				Update @TempExp
						Set 
							[PUA Profit]=[PUA Income]-[PUA Cost],
							[SOA Profit]=[SOA Income]-[SOA Cost],
							[AWC Profit]=[AWC Income]-[AWC Cost],
							[AF Profit]=[AF Income]-[AF Buying Destination],
							[AF P/ Share Destino]=([AF Income]-[AF Buying Destination])/2,
							[Total Gross Profit]=[AF Income]+[PUA Income]+[SOA Income]+[AWC Income]
					
			Select * from @TempExp
		End
GO
