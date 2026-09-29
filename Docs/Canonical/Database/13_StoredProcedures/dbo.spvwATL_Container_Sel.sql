SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help container_mas_imp_mar
--sp_help vwATL_Container
create procedure [dbo].[spvwATL_Container_Sel](
	@Num_proc	varChar(16),	
	@Num_Cont	varChar(15),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A'  or @Tipo = 'B'
	Begin
		select 
			Num_Proc,Num_Proc_Master,Item_Cont,Cd_Tp_Cont,Nome_Tp_Cont,Num_Cont,Num_Lacre,Dt_Vcto_Devol,
			Dt_Devol,Lacre_02,Lacre_03,Lacre_04,Peso_Bruto,VolumeM3,ID_ISO,Tara,DataDevCli,inspecao,
			Temperature,Vent_Status,Battery_Time,Cd_Tp_Volt,Graus,Peso_Liquido
		from 
			vwATL_Container TT with(nolock)			
	End

if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			Num_Proc,Num_Proc_Master,Item_Cont,Cd_Tp_Cont,Nome_Tp_Cont,Num_Cont,Num_Lacre,Dt_Vcto_Devol,
			Dt_Devol,Lacre_02,Lacre_03,Lacre_04,Peso_Bruto,VolumeM3,ID_ISO,Tara,DataDevCli,inspecao,
			Temperature,Vent_Status,Battery_Time,Cd_Tp_Volt,Graus,Peso_Liquido
		from 
			vwATL_Container TT with(nolock)			
		where
			num_proc = @Num_proc
	End
	
if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select 
			Num_Proc,Num_Proc_Master,Item_Cont,Cd_Tp_Cont,Nome_Tp_Cont,Num_Cont,Num_Lacre,Dt_Vcto_Devol,
			Dt_Devol,Lacre_02,Lacre_03,Lacre_04,Peso_Bruto,VolumeM3,ID_ISO,Tara,DataDevCli,inspecao,
			Temperature,Vent_Status,Battery_Time,Cd_Tp_Volt,Graus,Peso_Liquido
		from 
			vwATL_Container TT with(nolock)			
		where
			num_proc = @Num_proc AND Num_Cont = @Num_Cont
	End
	

	

	
GO
