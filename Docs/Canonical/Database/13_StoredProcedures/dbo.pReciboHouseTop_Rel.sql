SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pReciboHouseTop_Rel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE [dbo].[pReciboHouseTop_Rel]
(
@Num_Proc 		VarChar(16),
@Recibo 		VarChar(12) 
)
 AS	
	Declare @Emissao VarChar(10)
			
	If Left(@Num_Proc, 2) = 'EA' 
		Begin 
			
			Set @Emissao= (Select max(Dt_Conv_HEA) From Caixa_Hou_Exp_Aer Where Num_Rcb_HEA = @Recibo)			
			Select Distinct 
				@Emissao as Emissao, Consig.Nome_Raz_Soc as Consignatario, Consig.Num_CPF_CNPJ as CNPJ_Consig, Consig.Num_RG_IE as IE_Consig,
				Ps.Nome_Raz_Soc as RazaoSocial, Ps.Num_CPF_CNPJ as CNPJ, PS.Num_RG_IE as IE, 
				Ender.Rua as Endereco, Ender.Numero as Numero, Ender.Bairro as Bairro,  Ender.Cidade as Cidade, 
				Ender.UF as UF, HEA.Num_Proc_HEA as Num_Proc, HEA.HAWB_HEA as HAWB, 
				HEA.MAWB_HEA as MAWB, HEA.Cd_Org_HEA as Origem,  HEA.Cd_Dst_HEA as Destino
			From 
				House_Exp_Aer as HEA Join Cta_Cte_Hou_Exp_Aer as Cta on (HEA.Num_Proc_HEA = Cta.Num_Proc_HEA)				
				Join Caixa_Hou_Exp_Aer as Cxa on (Cta.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEA = Cxa.DC_HEA)
				Left Outer Join Pessoa as Ps on Cta.Cd_Cred_Dev_HEA = Ps.Cd_Pes
				Left Outer Join Endereco as Ender on (Ps.Cd_Pes = Ender.Cd_Pes and Cd_Tp_End = 'COM') 
				Left Outer Join Pessoa as Consig on Consig .Cd_Pes = '10017'
			Where
				Cxa.Num_Rcb_HEA = @Recibo and 
				HEA.Num_Proc_HEA = @Num_Proc
				
		End 

	If Left(@Num_Proc, 2) = 'EO' 
		Begin 
			
			Set @Emissao= (Select max(Dt_Conv_HEO) From Caixa_Hou_Exp_Out Where Num_Rcb_HEO = @Recibo)			
			Select Distinct 
				@Emissao as Emissao, Consig.Nome_Raz_Soc as Consignatario, Consig.Num_CPF_CNPJ as CNPJ_Consig, Consig.Num_RG_IE as IE_Consig,
				Ps.Nome_Raz_Soc as RazaoSocial, Ps.Num_CPF_CNPJ as CNPJ, PS.Num_RG_IE as IE, 
				Ender.Rua as Endereco, Ender.Numero as Numero, Ender.Bairro as Bairro,  Ender.Cidade as Cidade, 
				Ender.UF as UF, HEO.Num_Proc_HEO as Num_Proc, HEO.HAWB_HEO as HAWB, 
				HEO.MAWB_HEO as MAWB, HEO.Cd_Org_HEO as Origem,  HEO.Cd_Dst_HEO as Destino
			From 
				House_Exp_Out as HEO Join Cta_Cte_Hou_Exp_Out as Cta on (HEO.Num_Proc_HEO = Cta.Num_Proc_HEO)				
				Join Caixa_Hou_Exp_Out as Cxa on (Cta.Num_Proc_HEO = Cxa.Num_Proc_HEO and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEO = Cxa.DC_HEO)
				Left Outer Join Pessoa as Ps on Cta.Cd_Cred_Dev_HEO = Ps.Cd_Pes
				Left Outer Join Endereco as Ender on (Ps.Cd_Pes = Ender.Cd_Pes and Cd_Tp_End = 'COM') 
				Left Outer Join Pessoa as Consig on Consig .Cd_Pes = '10017'
			Where
				Cxa.Num_Rcb_HEO = @Recibo and 
				HEO.Num_Proc_HEO = @Num_Proc
				
		End 
	If Left(@Num_Proc, 2) = 'EM' 
		Begin 
			Set @Emissao= (Select max(Dt_Conv_HEM) From Caixa_Hou_Exp_Mar Where Num_Rcb_HEM = @Recibo)			
			Select Distinct 
				@Emissao as Emissao, Consig.Nome_Raz_Soc as Consignatario, Consig.Num_CPF_CNPJ as CNPJ_Consig, Consig.Num_RG_IE as IE_Consig,
				Ps.Nome_Raz_Soc as RazaoSocial, Ps.Num_CPF_CNPJ as CNPJ, PS.Num_RG_IE as IE, 
				Ender.Rua as Endereco, Ender.Numero as Numero, Ender.Bairro as Bairro,  Ender.Cidade as Cidade, 
				Ender.UF as UF, HEM.Num_Proc_HEM as Num_Proc, HEM.HAWB_HEM as HAWB, 
				HEM.MAWB_HEM as MAWB, HEM.Cd_Org_HEM as Origem,  HEM.Cd_Dst_HEM as Destino
			From 
				House_Exp_Mar as HEM Join Cta_Cte_Hou_Exp_Mar as Cta on (HEM.Num_Proc_HEM = Cta.Num_Proc_HEM)
				Join Caixa_Hou_Exp_Mar as Cxa on (Cta.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEM = Cxa.DC_HEM)
				Left Outer Join Pessoa as Ps on Cta.Cd_Cred_Dev_HEM = Ps.Cd_Pes
				Left Outer Join Endereco as Ender on (Ps.Cd_Pes = Ender.Cd_Pes and Cd_Tp_End = 'COM') 
				Left Outer Join Pessoa as Consig on Consig .Cd_Pes = '10017'
			Where
				Cxa.Num_Rcb_HEM = @Recibo and 
				HEM.Num_Proc_HEM = @Num_Proc
				
		End 
	If Left(@Num_Proc, 2) = 'IA' 
		Begin 
			Set @Emissao= (Select max(Dt_Conv_HIA) From Caixa_Hou_Imp_Aer Where Num_Rcb_HIA = @Recibo)			
			Select Distinct 
				@Emissao as Emissao, Consig.Nome_Raz_Soc as Consignatario, Consig.Num_CPF_CNPJ as CNPJ_Consig, Consig.Num_RG_IE as IE_Consig,
				Ps.Nome_Raz_Soc as RazaoSocial, Ps.Num_CPF_CNPJ as CNPJ, PS.Num_RG_IE as IE, 
				Ender.Rua as Endereco, Ender.Numero as Numero, Ender.Bairro as Bairro,  Ender.Cidade as Cidade, 
				Ender.UF as UF, HIA.Num_Proc_HIA as Num_Proc, HIA.HAWB_HIA as HAWB, 
				HIA.MAWB_HIA as MAWB, HIA.Cd_Org_HIA as Origem,  HIA.Cd_Dst_HIA as Destino
			From 
				House_Imp_Aer as HIA Join Cta_Cte_Hou_Imp_Aer as Cta on (HIA.Num_Proc_HIA = Cta.Num_Proc_HIA)	
				Join Caixa_Hou_Imp_Aer as Cxa on (Cta.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIA = Cxa.DC_HIA)
				Left Outer Join Pessoa as Ps on Cta.Cd_Cred_Dev_HIA = Ps.Cd_Pes
				Left Outer Join Endereco as Ender on (Ps.Cd_Pes = Ender.Cd_Pes and Cd_Tp_End = 'COM') 
				Left Outer Join Pessoa as Consig on Consig .Cd_Pes = '10017'
			Where
				Cxa.Num_Rcb_HIA = @Recibo and 
				HIA.Num_Proc_HIA = @Num_Proc
				
		End 
	If Left(@Num_Proc, 2) = 'IM' 
		Begin 
			Set @Emissao= (Select max(Dt_Conv_HIM) From Caixa_Hou_Imp_Mar Where Num_Rcb_HIM = @Recibo)			
			Select Distinct 
				@Emissao as Emissao, Consig.Nome_Raz_Soc as Consignatario, Consig.Num_CPF_CNPJ as CNPJ_Consig, Consig.Num_RG_IE as IE_Consig,
				Ps.Nome_Raz_Soc as RazaoSocial, Ps.Num_CPF_CNPJ as CNPJ, PS.Num_RG_IE as IE, 
				Ender.Rua as Endereco, Ender.Numero as Numero, Ender.Bairro as Bairro,  Ender.Cidade as Cidade, 
				Ender.UF as UF, HIM.Num_Proc_HIM as Num_Proc, HIM.HAWB_HIM as HAWB, 
				HIM.MAWB_HIM as MAWB, HIM.Cd_Org_HIM as Origem,  HIM.Cd_Dst_HIM as Destino
			From 
				House_Imp_Mar as HIM Join Cta_Cte_Hou_Imp_Mar as Cta on (HIM.Num_Proc_HIM = Cta.Num_Proc_HIM)	
				Join Caixa_Hou_Imp_Mar as Cxa on (Cta.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIM = Cxa.DC_HIM)
				Left Outer Join Pessoa as Ps on Cta.Cd_Cred_Dev_HIM = Ps.Cd_Pes
				Left Outer Join Endereco as Ender on (Ps.Cd_Pes = Ender.Cd_Pes and Cd_Tp_End = 'COM') 
				Left Outer Join Pessoa as Consig on Consig .Cd_Pes = '10017'
			Where
				Cxa.Num_Rcb_HIM = @Recibo and 
				HIM.Num_Proc_HIM = @Num_Proc
				
		End

	If Left(@Num_Proc, 2) = 'IO' 
		Begin 
			Set @Emissao= (Select max(Dt_Conv_HIO) From Caixa_Hou_Imp_Out Where Num_Rcb_HIO = @Recibo)			
			Select Distinct 
				@Emissao as Emissao, Consig.Nome_Raz_Soc as Consignatario, Consig.Num_CPF_CNPJ as CNPJ_Consig, Consig.Num_RG_IE as IE_Consig,
				Ps.Nome_Raz_Soc as RazaoSocial, Ps.Num_CPF_CNPJ as CNPJ, PS.Num_RG_IE as IE, 
				Ender.Rua as Endereco, Ender.Numero as Numero, Ender.Bairro as Bairro,  Ender.Cidade as Cidade, 
				Ender.UF as UF, HIO.Num_Proc_HIO as Num_Proc, HIO.HAWB_HIO as HAWB, 
				HIO.MAWB_HIO as MAWB, HIO.Cd_Org_HIO as Origem,  HIO.Cd_Dst_HIO as Destino
			From 
				House_Imp_Out as HIO Join Cta_Cte_Hou_Imp_Out as Cta on (HIO.Num_Proc_HIO = Cta.Num_Proc_HIO)	
				Join Caixa_Hou_Imp_Out as Cxa on (Cta.Num_Proc_HIO = Cxa.Num_Proc_HIO and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIO = Cxa.DC_HIO)
				Left Outer Join Pessoa as Ps on Cta.Cd_Cred_Dev_HIO = Ps.Cd_Pes
				Left Outer Join Endereco as Ender on (Ps.Cd_Pes = Ender.Cd_Pes and Cd_Tp_End = 'COM') 
				Left Outer Join Pessoa as Consig on Consig .Cd_Pes = '10017'
			Where
				Cxa.Num_Rcb_HIO = @Recibo and 
				HIO.Num_Proc_HIO = @Num_Proc
				
		End



GO
