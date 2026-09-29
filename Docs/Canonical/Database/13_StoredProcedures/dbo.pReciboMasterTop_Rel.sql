SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pReciboMasterTop_Rel
(
@Num_Proc 		VarChar(16),
@Recibo 		VarChar(12) 
)
 AS	
	Declare @Emissao VarChar(10)
			
	If Left(@Num_Proc, 2) = 'EA' 
		Begin 
			Set @Emissao= (Select max(Dt_Conv_MEA) From Caixa_Mas_Exp_Aer Where Num_Rcb_MEA = @Recibo)
			Select Distinct 
				@Emissao as Emissao, Consig.Nome_Raz_Soc as Consignatario, Consig.Num_CPF_CNPJ as CNPJ_Consig, Consig.Num_RG_IE as IE_Consig,
				Ps.Nome_Raz_Soc as RazaoSocial, Ps.Num_CPF_CNPJ as CNPJ, PS.Num_RG_IE as IE, 
				Ender.Rua as Endereco, Ender.Numero as Numero, Ender.Bairro as Bairro,  Ender.Cidade as Cidade, 
				Ender.UF as UF, MEA.Num_Proc_MEA as Num_Proc, '' as MAWB, 
				MEA.MAWB_MEA as MAWB, MEA.Cd_Org_MEA as Origem,  MEA.Cd_Dst_MEA as Destino
			From 
				Master_Exp_Aer as MEA Join Cta_Cte_Mas_Exp_Aer as Cta on (MEA.Num_Proc_MEA = Cta.Num_Proc_MEA)				
				Join Caixa_Mas_Exp_Aer as Cxa on (Cta.Num_Proc_MEA = Cxa.Num_Proc_MEA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MEA = Cxa.DC_MEA)
				Left Outer Join Pessoa as Ps on Cta.Cd_Cred_Dev_MEA = Ps.Cd_Pes
				Left Outer Join Endereco as Ender on (Ps.Cd_Pes = Ender.Cd_Pes and Cd_Tp_End = 'COM') 
				Left Outer Join Pessoa as Consig on Consig .Cd_Pes = '10017'
			Where
				Cxa.Num_Rcb_MEA = @Recibo and 
				MEA.Num_Proc_MEA = @Num_Proc
				
		End 
	If Left(@Num_Proc, 2) = 'EM' 
		Begin 
			Set @Emissao= (Select max(Dt_Conv_MEM) From Caixa_Mas_Exp_Mar Where Num_Rcb_MEM = @Recibo)			
			Select Distinct 
				@Emissao as Emissao, Consig.Nome_Raz_Soc as Consignatario, Consig.Num_CPF_CNPJ as CNPJ_Consig, Consig.Num_RG_IE as IE_Consig,
				Ps.Nome_Raz_Soc as RazaoSocial, Ps.Num_CPF_CNPJ as CNPJ, PS.Num_RG_IE as IE, 
				Ender.Rua as Endereco, Ender.Numero as Numero, Ender.Bairro as Bairro,  Ender.Cidade as Cidade, 
				Ender.UF as UF, MEM.Num_Proc_MEM as Num_Proc, '' as HAWB, 
				MEM.MAWB_MEM as MAWB, MEM.Cd_Org_MEM as Origem,  MEM.Cd_Dst_MEM as Destino
			From 
				Master_Exp_Mar as MEM Join Cta_Cte_Mas_Exp_Mar as Cta on (MEM.Num_Proc_MEM = Cta.Num_Proc_MEM)
				Join Caixa_Mas_Exp_Mar as Cxa on (Cta.Num_Proc_MEM = Cxa.Num_Proc_MEM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MEM = Cxa.DC_MEM)
				Left Outer Join Pessoa as Ps on Cta.Cd_Cred_Dev_MEM = Ps.Cd_Pes
				Left Outer Join Endereco as Ender on (Ps.Cd_Pes = Ender.Cd_Pes and Cd_Tp_End = 'COM') 
				Left Outer Join Pessoa as Consig on Consig .Cd_Pes = '10017'
			Where
				Cxa.Num_Rcb_MEM = @Recibo and 
				MEM.Num_Proc_MEM = @Num_Proc
				
		End 
	If Left(@Num_Proc, 2) = 'IA' 
		Begin 
			Set @Emissao= (Select max(Dt_Conv_MIA) From Caixa_Mas_Imp_Aer Where Num_Rcb_MIA = @Recibo)			
			Select Distinct 
				@Emissao as Emissao, Consig.Nome_Raz_Soc as Consignatario, Consig.Num_CPF_CNPJ as CNPJ_Consig, Consig.Num_RG_IE as IE_Consig,
				Ps.Nome_Raz_Soc as RazaoSocial, Ps.Num_CPF_CNPJ as CNPJ, PS.Num_RG_IE as IE, 
				Ender.Rua as Endereco, Ender.Numero as Numero, Ender.Bairro as Bairro,  Ender.Cidade as Cidade, 
				Ender.UF as UF, MIA.Num_Proc_MIA as Num_Proc, '' as HAWB, 
				MIA.MAWB_MIA as MAWB, MIA.Cd_Org_MIA as Origem,  MIA.Cd_Dst_MIA as Destino
			From 
				Master_Imp_Aer as MIA Join Cta_Cte_Mas_Imp_Aer as Cta on (MIA.Num_Proc_MIA = Cta.Num_Proc_MIA)	
				Join Caixa_Mas_Imp_Aer as Cxa on (Cta.Num_Proc_MIA = Cxa.Num_Proc_MIA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MIA = Cxa.DC_MIA)
				Left Outer Join Pessoa as Ps on Cta.Cd_Cred_Dev_MIA = Ps.Cd_Pes
				Left Outer Join Endereco as Ender on (Ps.Cd_Pes = Ender.Cd_Pes and Cd_Tp_End = 'COM') 
				Left Outer Join Pessoa as Consig on Consig .Cd_Pes = '10017'
			Where
				Cxa.Num_Rcb_MIA = @Recibo and 
				MIA.Num_Proc_MIA = @Num_Proc
				
		End 
	If Left(@Num_Proc, 2) = 'IM' 
		Begin 
			Set @Emissao= (Select max(Dt_Conv_MIM) From Caixa_Mas_Imp_Mar Where Num_Rcb_MIM = @Recibo)			
			Select Distinct 
				@Emissao as Emissao, Consig.Nome_Raz_Soc as Consignatario, Consig.Num_CPF_CNPJ as CNPJ_Consig, Consig.Num_RG_IE as IE_Consig,
				Ps.Nome_Raz_Soc as RazaoSocial, Ps.Num_CPF_CNPJ as CNPJ, PS.Num_RG_IE as IE, 
				Ender.Rua as Endereco, Ender.Numero as Numero, Ender.Bairro as Bairro,  Ender.Cidade as Cidade, 
				Ender.UF as UF, MIM.Num_Proc_MIM as Num_Proc, '' as HAWB, 
				MIM.MAWB_MIM as MAWB, MIM.Cd_Org_MIM as Origem,  MIM.Cd_Dst_MIM as Destino
			From 
				Master_Imp_Mar as MIM Join Cta_Cte_Mas_Imp_Mar as Cta on (MIM.Num_Proc_MIM = Cta.Num_Proc_MIM)	
				Join Caixa_Mas_Imp_Mar as Cxa on (Cta.Num_Proc_MIM = Cxa.Num_Proc_MIM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MIM = Cxa.DC_MIM)
				Left Outer Join Pessoa as Ps on Cta.Cd_Cred_Dev_MIM = Ps.Cd_Pes
				Left Outer Join Endereco as Ender on (Ps.Cd_Pes = Ender.Cd_Pes and Cd_Tp_End = 'COM') 
				Left Outer Join Pessoa as Consig on Consig .Cd_Pes = '10017'
			Where
				Cxa.Num_Rcb_MIM = @Recibo and 
				MIM.Num_Proc_MIM = @Num_Proc
				
		End



GO
