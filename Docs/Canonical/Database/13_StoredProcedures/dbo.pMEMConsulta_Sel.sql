SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMEMConsulta_Sel    Script Date: 28/10/2002 14:37:39 ******/
CREATE PROCEDURE pMEMConsulta_Sel
(
@Master		VarChar(25)='', 
@Origem		Char(3)='', 
@Destino		Char(3)='',
@SaidaIN		VarChar(16)='',
@SaidaFN		VarChar(16)=''
)
 AS
-- Num_Proc_MIM, MAWB_MIM, CIMC_MIM, Origem, Destino, Dt_Atrac_MIM, Dt_Oper_MIM, Dt_Oper_MIM, Nome_Armazem , Nome_Terminal
	Declare @Sql 		VarChar(2000) 
	Declare @Comp		Bit 
	Set @Sql = 'Select  Num_Proc_MEM, MAWB_MEM, Cd_Org_MEM, Orig.Nome_Local as Origem, Cd_Dst_MEM, Dest.Nome_Local as Destino, Dt_Saida_MEM, Dt_Estuf_MEM ' 
	Set @Sql = @Sql + ' From Master_Exp_Mar as MEM Left Outer Join Localidade as Orig  on MEM.Cd_Org_MEM = Orig.Cd_Local Left Outer Join Localidade as Dest on MEM.Cd_Dst_MEM = Orig.Cd_Local   Where '
	Set @Comp = 0 
	If @Master <> '' 
		Begin 
			Set @Comp =  1 
			Set @Sql = @Sql +  ' MAWB_MEM = ''' + @Master +  ''''
		End 		
	If @Origem <> '' 
		Begin 
			If @Comp = 1 
				Set @Sql = @Sql + ' And Cd_Org_MEM = ''' + @Origem +  ''''
			Else
				Begin 
					Set @Comp = 1 
					Set @Sql = @Sql + '  Cd_Org_MEM = ''' + @Origem +  ''''
				End 
		End 
	If @Destino <> '' 		
		Begin 
			If @Comp = 1 
				Set @Sql = @Sql + ' And Cd_Dst_MEM = ''' + @Destino + ''''
			Else
				Begin 
					Set @Comp = 1 
					Set @Sql = @Sql + ' Cd_Dst_MEM  = ''' + @Destino + ''''
				End 			
		End 
	If @SaidaIn <> '' 		
		Begin 
			If @Comp = 1 
				Set @Sql = @Sql + ' And Convert(Datetime, Dt_Saida_MIM,103)  >=  ''' + @SaidaIn + ''''
			Else
				Begin 
					Set @Comp = 1 
					Set @Sql = @Sql + ' Convert(Datetime, Dt_Saida_MIM,103)  >=  ''' + @SaidaIn + ''''
				End 			
		End 
	If @SaidaFn <> '' 		
		Begin 
			If @Comp = 1 
				Set @Sql = @Sql + ' And Convert(Datetime, Dt_Saida_MEM,103)  <=  ''' +  @SaidaFN + ''' '
			Else
				Begin 
					Set @Comp = 1 
					Set @Sql = @Sql + ' Convert(Datetime, Dt_Saida_MEM,103) <=  ''' + @SaidaFN + ''''
				End 			
		End
	If @Comp = 1 
	Execute (@Sql)



GO
