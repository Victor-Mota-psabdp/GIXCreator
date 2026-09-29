SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMIMConsulta_Sel
(
@Master		VarChar(25)='', 
@CIMC			VarChar(12)='',
@Origem		Char(3)='', 
@Destino		Char(3)='',
@AtracIN		VarChar(16)='',
@AtracFN		VarChar(16)=''
)
 AS
-- Num_Proc_MIM, MAWB_MIM, CIMC_MIM, Origem, Destino, Dt_Atrac_MIM, Dt_Oper_MIM, Dt_Oper_MIM, Nome_Armazem , Nome_Terminal
	Declare @Sql 		VarChar(2000) 
	Declare @Comp		Bit 
	Set @Sql = 'Select  Num_Proc_MIM, MAWB_MIM, CIMC_MIM, Cd_Org_MIM, Orig.Nome_Local as Origem, Cd_Dst_MIM, Dest.Nome_Local as Destino,Nome_Armazem , Nome_Terminal, Dt_Atrac_MIM, Dt_Oper_MIM, MIM.Cd_Armazem, MIM.Cd_Terminal  ' 
	Set @Sql = @Sql + ' From Master_Imp_Mar as MIM Left Outer Join Localidade as Orig  on MIM.Cd_Org_MIM = Orig.Cd_Local Left Outer Join Localidade as Dest on MIM.Cd_Dst_MIM = Orig.Cd_Local   Left Outer Join Armazem as Armz on MIM.Cd_Armazem = Armz.Cd_Armazem Left Outer Join Terminal as Term on MIM.Cd_Terminal = Term.Cd_Terminal  Where '
	Set @Comp = 0 
	If @Master <> '' 
		Begin 
			Set @Comp =  1 
			Set @Sql = @Sql +  ' MAWB_MIM = ''' + @Master +  ''''
		End 		
	If @CIMC <> '' 
		Begin 
			If @Comp = 1 
				Set @Sql = @Sql + ' And CIMC_MIM = ''' + @CIMC + ''''
			Else
				Begin 
					Set @Comp = 1 
					Set @Sql = @Sql + ' CIMC_MIM = ''' + @CIMC + ''''
				End 
		End 
	If @Origem <> '' 
		Begin 
			If @Comp = 1 
				Set @Sql = @Sql + ' And Cd_Org_MIM = ''' + @Origem +  ''''
			Else
				Begin 
					Set @Comp = 1 
					Set @Sql = @Sql + '  Cd_Org_MIM = ''' + @Origem +  ''''
				End 
		End 
	If @Destino <> '' 		
		Begin 
			If @Comp = 1 
				Set @Sql = @Sql + ' And Cd_Dst_MIM = ''' + @Destino + ''''
			Else
				Begin 
					Set @Comp = 1 
					Set @Sql = @Sql + ' Cd_Dst_MIM  = ''' + @Destino + ''''
				End 			
		End 
	If @AtracIn <> '' 		
		Begin 
			If @Comp = 1 
				Set @Sql = @Sql + ' And Convert(Datetime, Dt_Atrac_MIM,103)  >=  ''' + @AtracIn + ''''
			Else
				Begin 
					Set @Comp = 1 
					Set @Sql = @Sql + ' Convert(Datetime, Dt_Atrac_MIM,103)  >=  ''' + @AtracIn + ''''
				End 			
		End 
	If @AtracFn <> '' 		
		Begin 
			If @Comp = 1 
				Set @Sql = @Sql + ' And Convert(Datetime, Dt_Atrac_MIM,103)  <=  ''' +  @AtracFN + ''' '
			Else
				Begin 
					Set @Comp = 1 
					Set @Sql = @Sql + ' Convert(Datetime, Dt_Atrac_MIM,103) <=  ''' + @AtracFN + ''''
				End 			
		End
	If @Comp = 1 
	Execute (@Sql)



GO
