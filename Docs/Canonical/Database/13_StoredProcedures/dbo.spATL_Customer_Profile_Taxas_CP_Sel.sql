SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_Customer_Profile_Taxas_CP_Sel]'IM','1','p'
--[spATL_Customer_Profile_Taxas_CP_Sel]'IM','1','C'
--select * from taxas_cp
--select * from Customer_Profile where ID_CP = 75
--select * from Customer_Profile_Taxas where ID_CP = 75
--select * from Customer_Profile_Taxas where Vlr_Compra = 4
CREATE Procedure [dbo].[spATL_Customer_Profile_Taxas_CP_Sel]--'IM','1','C'
(
	@ID_CP				int,
	@Cd_Tp_Modal		VARCHAR(2),
	@Cd_Tp_Carga		VARCHAR(1),
	@Tipo				char(1)
)

as

if @Tipo = 'C' 
	begin	
		select 
			Convert(varchar(10),'')	[Status],
			@ID_CP						[Code],
			CPT.Cd_Tp_Tx				[Charge Code],
			TT.Nome_Tp_Tx				[Charge Name],			
			NULL						[Supplier Code],
			NULL						[Supplier Name],
			NULL						[Document Code],
			NULL						[Document Name],
			CPT.IVA						[IVA],
			TC.Cd_CV					[Selling Code],
			TC.Descricao_CV				[Selling Name],						
			CPT.Moeda					[Selling Currency Code],
			TM.Nome_Tp_Moeda			[Selling Currency Name],			
			NULL						[Selling Range Code],
			NULL						[Selling Range Name],
			CPT.Vlr_Taxa				[Selling Value],
			NULL						[Selling MIN Value],
			NULL						[Selling MAX Value],							
			TC.Cd_CV					[Buying Code],
			TC.Descricao_CV				[Buying Name],						
			CPT.Moeda					[Buying Currency Code],
			TM.Nome_Tp_Moeda			[Buying Currency Name],			
			NULL						[Buying Range Code],
			NULL						[Buying Range Name],
			CPT.Vlr_Taxa				[Buying Value],
			NULL						[Buying MIN Value],
			NULL						[Buying MAX Value],				
			NULL						[Notes]	
		from Taxas_CP CPT		with (nolock)			
			left join tipo_taxa TT	on TT.cd_tp_tx = CPT.CD_Tp_Tx collate Latin1_General_CI_AI
			left join tipo_moeda TM	on TM.Cd_Tp_Moeda = CPT.Moeda collate Latin1_General_CI_AI	
			left join Tipo_Compra_Venda_CP TC with (nolock) on TC.Cd_CV = 'J'			
	
		where 
			CPT.Modal collate Latin1_General_CI_AI = @Cd_Tp_Modal 
			and CPT.cd_Tp_Carga = @Cd_Tp_Carga
	END
if @Tipo = 'P' 
	BEGIN
		select 
			Convert(varchar(10),'')	[Status],
			@ID_CP						[Code],
			CPT.Cd_Tp_Tx				[Charge Code],
			TT.Nome_Tp_Tx				[Charge Name],			
			NULL						[Supplier Code],
			NULL						[Supplier Name],
			NULL						[Document Code],
			NULL						[Document Name],
			CPT.IVA						[IVA],
			TC.Cd_CV					[Selling Code],
			TC.Descricao_CV				[Selling Name],						
			CPT.Moeda					[Selling Currency Code],
			TM.Nome_Tp_Moeda			[Selling Currency Name],			
			NULL						[Selling Range Code],
			NULL						[Selling Range Name],
			CPT.Vlr_Taxa				[Selling Value],
			NULL						[Selling MIN Value],
			NULL						[Selling MAX Value],							
			TC.Cd_CV					[Buying Code],
			TC.Descricao_CV				[Buying Name],						
			CPT.Moeda					[Buying Currency Code],
			TM.Nome_Tp_Moeda			[Buying Currency Name],			
			NULL						[Buying Range Code],
			NULL						[Buying Range Name],
			CPT.Vlr_Taxa				[Buying Value],
			NULL						[Buying MIN Value],
			NULL						[Buying MAX Value],				
			NULL						[Notes]	
		from Taxas_CP CPT		with (nolock)			
			left join tipo_taxa TT	on TT.cd_tp_tx = CPT.CD_Tp_Tx collate Latin1_General_CI_AI
			left join tipo_moeda TM	on TM.Cd_Tp_Moeda = CPT.Moeda collate Latin1_General_CI_AI
			left outer	join Tipo_Compra_Venda_CP TC with (nolock) on TC.Cd_CV = 'J'				
		where 
			CPT.Modal = @Cd_Tp_Modal 
			and CPT.cd_Tp_Carga = @cd_Tp_Carga 
			and CPT.moeda = 'USD'
	END

GO
