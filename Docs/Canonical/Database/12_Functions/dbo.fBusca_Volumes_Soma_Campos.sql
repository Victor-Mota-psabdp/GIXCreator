SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fBusca_Volumes_Soma_Campos]
(
@Processo	Varchar(16),
@Tipo varchar(25)
)
RETURNS Varchar(400)
AS  
BEGIN 
	Declare @N_VOL	VarChar(400) 

	if @Tipo = 'Qtd_Vol_EA'
		set @N_VOL = (select (convert(varchar(30),sum(Qtd_Vol_EA))) Volume  from Volume_Exp_Aer VOL 
		Join house_exp_Aer HOU on VOL.Num_Proc_HEA = HOU.Num_Proc_HEA
		join Master_Exp_Aer Mea on MEA.num_proc_mea = HOU.num_proc_mea		
		where MEA.num_proc_mea = @Processo)
	else if @Tipo = 'Compr_EA'
		set @N_VOL = (select (convert(varchar(30),sum(Compr_EA))) Volume  from Volume_Exp_Aer VOL 
		Join house_exp_Aer HOU on VOL.Num_Proc_HEA = HOU.Num_Proc_HEA
		join Master_Exp_Aer Mea on MEA.num_proc_mea = HOU.num_proc_mea		
		where MEA.num_proc_mea = @Processo)
	else if @Tipo = 'Largura_EA'
		set @N_VOL = (select (convert(varchar(30),sum(Largura_EA))) Volume  from Volume_Exp_Aer VOL 
		Join house_exp_Aer HOU on VOL.Num_Proc_HEA = HOU.Num_Proc_HEA
		join Master_Exp_Aer Mea on MEA.num_proc_mea = HOU.num_proc_mea		
		where MEA.num_proc_mea = @Processo)
	else if @Tipo = 'Altura_EA'
		set @N_VOL = (select (convert(varchar(30),sum(Altura_EA))) Volume  from Volume_Exp_Aer VOL 
		Join house_exp_Aer HOU on VOL.Num_Proc_HEA = HOU.Num_Proc_HEA
		join Master_Exp_Aer Mea on MEA.num_proc_mea = HOU.num_proc_mea		
		where MEA.num_proc_mea = @Processo)		
	else if @Tipo = 'Peso_Bruto_EA'
		set @N_VOL = (select (convert(varchar(30),sum(Peso_Bruto_EA))) Volume  from Volume_Exp_Aer VOL
		Join house_exp_Aer HOU on VOL.Num_Proc_HEA = HOU.Num_Proc_HEA
		join Master_Exp_Aer Mea on MEA.num_proc_mea = HOU.num_proc_mea		
		where MEA.num_proc_mea = @Processo)
	else if @Tipo = 'Descr'
		set @N_VOL = (select top 1 NG.Descr Volume  from nature_goods NG
		Join house_exp_Aer HOU on NG.Num_Proc = HOU.Num_Proc_HEA
		join Master_Exp_Aer Mea on MEA.num_proc_mea = HOU.num_proc_mea		
		where MEA.num_proc_mea = @Processo)

		
return @N_VOL

END
GO
