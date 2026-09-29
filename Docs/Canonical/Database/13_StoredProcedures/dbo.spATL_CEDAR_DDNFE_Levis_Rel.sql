SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_CEDAR_DDNFE_Levis_Rel]--'2024-03-01','2024-03-31'
(
	@DtInicial datetime,
	@DtFinal datetime
)

AS
Declare @Cd_Grupo varchar(10)    
Declare @Grupo varchar(50)    
set @Cd_Grupo = (select Cd_Pes_Grupo from Pessoa P with(nolock) join Grupo G with(nolock) on P.Cd_Pes = G.Cd_Pes_Grupo where P.Apelido = 'GRUPO LEVIS')        

	declare @TAB table
	(	
	[Importing Country] varchar(100),
	[Entry Number] varchar(25),
	[Entry Number 2] varchar(25),
	[File Number] varchar(16),
	[Commercial Invoice Number] varchar(2500),
	[Entry Line Number] varchar(25),
	[PO Number] varchar(250),
	[PO Line] varchar(25),
	[ISD Number] varchar(2500),
	[Manufacturer Name] varchar(100),
	[Vendor Name] varchar(250)
	)

		Begin
		insert into
			@TAB (
			[Importing Country],
			[Entry Number],
			[Entry Number 2],
			[File Number],
			[Commercial Invoice Number],
			[Entry Line Number],
			[PO Number],
			[PO Line],
			[ISD Number],
			[Manufacturer Name],
			[Vendor Name]
			)

			
					select 
					
					'BR',
					substring(DI.nDI, 1, 2) + '/' + substring(DI.nDI, 3, 7) + '-' + substring(DI.nDI, 10, 9),
					--dbo.fBusca_Docs_PO_Modal(D.Num_Proc,5),
					'',
					D.Num_Proc,
					dbo.fBusca_Docs_PO_Modal(D.Num_Proc,2),
					IPDA.nadicao,
					--PO,
					'',
					(case when (select dbo.fBusca_Docs_PO_Modal(D.Num_Proc,11)) = 'SEM NUMERO' 
					then '' 
					else (select dbo.fBusca_Docs_PO_Modal(D.Num_Proc,11)) end),
					'',
					DC.xNome,
					dbo.fBusca_Docs_PO_Modal(D.Num_Proc,1)
					
				
					
					

							
					from 
					ATL_BR.dbo.Danfe_Base D with(nolock)
					join ATL_BR.dbo.Danfe_Item I with(nolock) on I.Id_Danfe = i.id_Item
					join ATL_BR.dbo.Danfe_Item_Produto IP with(nolock) on IP.Id_Danfe = D.Id_Danfe
					join ATL_BR.dbo.Danfe_Item_Prod_DI DI with(nolock) on DI.Id_Danfe = D.Id_Danfe and DI.id_item=IP.id_Item and Ip.cProd = Di.cProd
					left join ATL_BR.dbo.Danfe_Item_Prod_DI_Adicao IPDA with(nolock) on IPDA.nDI = DI.nDI and IPDA.Id_Danfe = DI.Id_Danfe and IPDA.id_item=DI.id_Item

					left join ATL_BR.dbo.Danfe_Cia DC with(nolock) on DC.Id_Danfe = D.Id_Danfe and DC.Tipo = 'D'

					where
					D.Num_Proc = 'IMLVS202401014BR'
		End
	
		Begin
			select 
					[Importing Country],
					[Entry Number],
					[Entry Number 2],
					[File Number],
					[Commercial Invoice Number],
					[Entry Line Number],
					--[PO Number],
					[PO Line],
					[ISD Number],
					[Manufacturer Name],
					[Vendor Name]
			from @TAB
		End
GO
