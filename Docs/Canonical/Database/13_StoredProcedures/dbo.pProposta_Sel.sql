SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE    PROCEDURE pProposta_Sel 
(
@Tipo			Char(1)='', 
@Modal 		VarChar(2) = '',
@Proposta		VarChar(12)=''
)
AS
Declare  @Dt_Limite	Datetime 
Set @Dt_Limite = '2004-04-01'
--@tipo = M (Modal )
--@tipo = C (Cliente )  
If rtrim(@Proposta) = '' 	
	Begin 
		If @Tipo = 'M'
			Begin 
				If @Modal = 'IM'
					Select 
						Num_Prop_IM as Proposta
					From 
						Proposta_Imp_Mar
					Where
						Convert(DateTime, Dt_PIM, 105) > =  @Dt_Limite  and  (Dt_Fchto_PIM is null or dt_fchto_pIM='') and Cancel_PIM='N'
					Order by 
						Num_Prop_IM  Desc 
				If @Modal = 'EM'
					Select 
						Num_Prop_EM as Proposta
					From 
						Proposta_Exp_Mar
					Where
						Convert(DateTime, Dt_PEM, 105) > =  @Dt_Limite   and (Dt_Fchto_PEm is null or dt_fchto_pem='') and Cancel_PEM='N'
					Order by 
						Num_Prop_EM  Desc 
				If @Modal = 'IA'
					Select 
						Num_Prop_IA as Proposta
					From 
						Proposta_Imp_Aer
					Where
						Convert(DateTime, Dt_PIA, 105) > =  @Dt_Limite and (Dt_Fchto_PiA is null or dt_fchto_pia='') and Cancel_PIA='N'
					Order by 
						Num_Prop_IA  Desc 
						
				If @Modal = 'EA'
					Select 
						Num_Prop_EA as Proposta
					From 
						Proposta_Exp_Aer
					Where
						Convert(DateTime, Dt_PEA, 105) > =  @Dt_Limite and (Dt_Fchto_PEA is null or dt_fchto_pea='') and Cancel_PEA='N'
					Order by 
						Num_Prop_EA  Desc 
	
			End 
	
		If @Tipo = 'C'
			Begin 
					Select 
						Num_Prop_IM  as Proposta, Cli.Apelido as Cliente, Cli.Cd_Pes as Cd_Pes
					From 
						Proposta_Imp_Mar as PIM Join Pessoa as Cli on Cli.Cd_Pes = PIM.Cd_Import_PIM
					Where
						Convert(DateTime, Dt_PIM, 105) > =  @Dt_Limite
	
					Union 
					
					Select 
						Num_Prop_EM as Proposta, Cli.Apelido as Cliente, Cli.Cd_Pes as Cd_Pes 
					From 
						Proposta_Exp_Mar  as PEM Join Pessoa as Cli on Cli.Cd_Pes = PEM.Cd_Export_PEM
					Where
						Convert(DateTime, Dt_PEM, 105) > =  @Dt_Limite
	
					Union 
	
					Select 
						Num_Prop_IA as Proposta,  Cli.Apelido as Cliente , Cli.Cd_Pes as Cd_Pes
					From 
						Proposta_Imp_Aer  as PIA Join Pessoa as Cli on Cli.Cd_Pes = PIA.Cd_Import_PIA
					Where
						Convert(DateTime, Dt_PIA, 105) > =  @Dt_Limite
	
						
					Union 
	
					Select 
						Num_Prop_EA as Proposta, Cli.Apelido as Cliente  , Cli.Cd_Pes as Cd_Pes
					From 
						Proposta_Exp_Aer as PEA Join Pessoa as Cli on Cli.Cd_Pes = PEA.Cd_Export_PEA
					Where
						Convert(DateTime, Dt_PEA, 105) > =  @Dt_Limite
	
					Order by 
						Cliente
	
	
			End
	End 
Else
	Begin 
		If Left(@Proposta, 2) = 'IM'
			Select 
				Num_Prop_IM as Proposta, Cli.Cd_Pes as Cd_Pes, Cli.Apelido as Pessoa 
			From 
				Proposta_Imp_Mar as PIM Join Pessoa as Cli on  Cli.Cd_Pes = PIM.Cd_Import_PIM 
			Where
				Num_Prop_IM = @Proposta
			Order by 
				Num_Prop_IM  Desc 
		If Left(@Proposta, 2) = 'EM'
			Select 
				Num_Prop_EM as Proposta, Cli.Cd_Pes as Cd_Pes, Cli.Apelido as Pessoa
			From 
				Proposta_Exp_Mar as PEM Join Pessoa as Cli on  Cli.Cd_Pes = PEM.Cd_Export_PEM 
			Where
				Num_Prop_EM = @Proposta
			Order by 
				Num_Prop_EM  Desc 
		If Left(@Proposta, 2) = 'IA'
			Select 
				Num_Prop_IA as Proposta, Cli.Cd_Pes as Cd_Pes, Cli.Apelido as Pessoa
			From 
				Proposta_Imp_Aer as PIA Join Pessoa as Cli on Cli.Cd_Pes = PIA.Cd_Import_PIA 
			Where
				Num_Prop_IA = @Proposta
			Order by 
				Num_Prop_IA  Desc 
				
		If Left(@Proposta, 2) = 'EA'
			Select 
				Num_Prop_EA as Proposta, Cli.Cd_Pes as Cd_Pes, Cli.Apelido as Pessoa
			From 
				Proposta_Exp_Aer as PEA Join Pessoa as Cli on Cli.Cd_Pes = PEA.Cd_Export_PEA 
			Where
				Num_Prop_EA = @Proposta
			Order by 
				Num_Prop_EA  Desc 
	End




GO
