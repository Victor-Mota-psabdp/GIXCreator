SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spAtualizaParidadeAut_Ins]

AS


declare @DataInicial datetime
declare @DataParidade datetime
Set @DataInicial=convert(datetime,convert(Varchar(10),getdate()-15,103),103)

While (@DataInicial < getdate()-1)
	Begin
		if not exists(select cd_tp_par from paridade where convert(datetime,dt_par,105)=@datainicial and cd_tp_par='OFC' and cd_tp_moeda='USD')
			Begin
				Set @DataParidade=@DataInicial
				While not exists(select cd_tp_par from paridade where convert(datetime,dt_par,105)=@DataParidade and cd_tp_par='OFC' and cd_tp_moeda='USD')
					Begin
						Set @Dataparidade=@DataParidade-1
					
					End
				print 'No dia: ' + convert(varchar(10),@DataInicial ,103) + '	NÃO EXISTE paridade' + ' Mas no dia ' + convert(varchar(10),@DataParidade ,103) + ' TEM'
				insert paridade
				select convert(varchar(10),@datainicial,103),cd_tp_moeda,cd_tp_par,par_moeda from paridade where convert(datetime,dt_par,105)=@dataparidade

			End
		ELSE
			Begin
				print 'No dia: ' + convert(varchar(10),@DataInicial ,103) + '	EXISTE paridade'
			End
		SET @DataInicial=@DataInicial + 1
	
	End
	
	
GO
