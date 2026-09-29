SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP CUSTOMER_PROFILE_TAXAS
CREATE Procedure [dbo].[spATL_Customer_Profile_Taxas_Sel]-- '10','D'
	@ID_CP				int,
	@Tipo				char(1)
as

if @Tipo = 'A' or @Tipo = 'B'
	Begin	
		select 
			Convert(varchar(10),'Saved') [Status],
			CPT.ID_CP				[Code],
			CPT.Cd_Tp_Tx			[Charge Code],
			TT.Nome_Tp_Tx			[Charge Name],
			CPT.Cd_Fornecedor		[Supplier Code],
			Supplier.Apelido		[Supplier Name],
			Convert(varchar(10),CPT.Id_DC)				[Document Code],
			TDC.Nome_DC				[Document Name],
			CPT.IVA					[IVA],
			CPT.Cd_Tipo_Venda		[Selling Code],
			TV.Descricao_CV			[Selling Name],						
			CPT.Cd_Tp_Moeda_Venda	[Selling Currency Code],
			TMV.Nome_Tp_Moeda		[Selling Currency Name],			
			CPT.Cd_Range_Venda		[Selling Range Code],
			TRV.Range_Descricao		[Selling Range Name],
			CPT.Vlr_Venda			[Selling Value],
			CPT.Vlr_Min_Venda		[Selling MIN Value],
			CPT.Vlr_Max_Venda		[Selling MAX Value],
			CPT.Cd_Tipo_Compra		[Buying Code],
			TC.Descricao_CV			[Buying Name],						
			CPT.Cd_Tp_Moeda_Compra	[Buying Currency Code],
			TMC.Nome_Tp_Moeda		[Buying Currency Name],			
			CPT.Cd_Range_Compra		[Buying Range Code],
			TRC.Range_Descricao		[Buying Range Name],
			Vlr_Compra				[Buying Value],
			Vlr_Min_Compra			[Buying MIN Value],
			Vlr_Max_Compra			[Buying MAX Value],			
			CPT.Campo_Obs_Taxas		[Notes]	
		from Customer_Profile_Taxas CPT		with (nolock)
			--join Customer_Profile CP		with (nolock) on CP.ID_CP = CPT.ID_CP	
			join Tipo_Taxa TT with (nolock) on TT.Cd_Tp_Tx = CPT.Cd_Tp_Tx	
			left outer	join Pessoa Supplier	with (nolock) on Supplier.Cd_Pes=CPT.Cd_Fornecedor
			left outer	join Tipo_Compra_Venda_CP TC with (nolock) on TC.Cd_CV = CPT.Cd_Tipo_Compra
			left outer	join Tipo_moeda TMC	with (nolock) on TMC.Cd_Tp_Moeda = CPT.Cd_Tp_Moeda_Compra
			left outer	join Tipo_Range_CP TRC	with (nolock) on TRC.Cd_Range = CPT.Cd_Range_Compra
			
			left outer	join Tipo_Compra_Venda_CP TV with (nolock) on TV.Cd_CV = CPT.Cd_Tipo_Venda
			left outer	join Tipo_moeda TMV	with (nolock) on TMV.Cd_Tp_Moeda = CPT.Cd_Tp_Moeda_Venda
			left outer	join Tipo_Range_CP TRV	with (nolock) on TRV.Cd_Range = CPT.Cd_Range_Venda
			
			left outer	join Tipo_Doc_Cliente TDC with (nolock) on TDC.ID_DC = CPT.ID_DC		
			
		where
			CPT.ID_CP = @ID_CP 
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin	
		select 
			Convert(varchar(10),'Saved') [Status],
			CPT.ID_CP				[Code],
			CPT.Cd_Tp_Tx			[Charge Code],
			TT.Nome_Tp_Tx			[Charge Name],
			CPT.Cd_Fornecedor		[Supplier Code],
			Supplier.Apelido		[Supplier Name],
			Convert(varchar(10),CPT.Id_DC)				[Document Code],
			TDC.Nome_DC				[Document Name],
			CPT.IVA					[IVA],	
		
			CPT.Cd_Tipo_Venda		[Selling Code],
			TV.Descricao_CV			[Selling Name],						
			CPT.Cd_Tp_Moeda_Venda	[Selling Currency Code],
			TMV.Nome_Tp_Moeda		[Selling Currency Name],			
			CPT.Cd_Range_Venda		[Selling Range Code],
			TRV.Range_Descricao		[Selling Range Name],
			CPT.Vlr_Venda			[Selling Value],
			CPT.Vlr_Min_Venda		[Selling MIN Value],
			CPT.Vlr_Max_Venda		[Selling MAX Value],
				CPT.Cd_Tipo_Compra		[Buying Code],
			TC.Descricao_CV			[Buying Name],						
			CPT.Cd_Tp_Moeda_Compra	[Buying Currency Code],
			TMC.Nome_Tp_Moeda		[Buying Currency Name],			
			CPT.Cd_Range_Compra		[Buying Range Code],
			TRC.Range_Descricao		[Buying Range Name],
			Vlr_Compra				[Buying Value],
			Vlr_Min_Compra			[Buying MIN Value],
			Vlr_Max_Compra			[Buying MAX Value],			
			CPT.Campo_Obs_Taxas		[Notes]	
		from Customer_Profile_Taxas CPT		with (nolock)
			--join Customer_Profile CP		with (nolock) on CP.ID_CP = CPT.ID_CP	
			join Tipo_Taxa TT with (nolock) on TT.Cd_Tp_Tx = CPT.Cd_Tp_Tx	
			left outer	join Pessoa Supplier	with (nolock) on Supplier.Cd_Pes=CPT.Cd_Fornecedor
			left outer	join Tipo_Compra_Venda_CP TC with (nolock) on TC.Cd_CV = CPT.Cd_Tipo_Compra
			left outer	join Tipo_moeda TMC	with (nolock) on TMC.Cd_Tp_Moeda = CPT.Cd_Tp_Moeda_Compra
			left outer	join Tipo_Range_CP TRC	with (nolock) on TRC.Cd_Range = CPT.Cd_Range_Compra
			
			left outer	join Tipo_Compra_Venda_CP TV with (nolock) on TV.Cd_CV = CPT.Cd_Tipo_Venda
			left outer	join Tipo_moeda TMV	with (nolock) on TMV.Cd_Tp_Moeda = CPT.Cd_Tp_Moeda_Venda
			left outer	join Tipo_Range_CP TRV	with (nolock) on TRV.Cd_Range = CPT.Cd_Range_Venda
			
			left outer	join Tipo_Doc_Cliente TDC with (nolock) on TDC.ID_DC = CPT.ID_DC	
					
		where
			CPT.ID_CP = @ID_CP 
	End

GO
