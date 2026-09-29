SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








--select dbo.fBusca_EmbalagensVOL('2112')
--select * from produto_cliente

CREATE	FUNCTION [dbo].[fBusca_EmbalagensVOL] 
(
@ID_INV	int
)
RETURNS Varchar(400)
AS  
BEGIN
	Declare @N_ID	VarChar(400)
	Declare @ID	varchar(400)
	Declare @Idioma varchar(3)
	set @idioma = (select linguagem from Invoice_Cliente where id_inv = @id_inv)

	Declare Cur_ID cursor for 
		--EXPORTAÇÃO
		Select
			convert(varchar(max),VOL.qtd_Vol_EA) + ' ' +
			VE.Nome_Tp_Embal + 
			(case when inv_cli.linguagem = 'ESP' then ' con ' else ' with ' end) +
			convert(varchar(max),Inv_Det.Quantidade) + ' ' +
			(case when TE.Nome_Tp_Embal = 'Tambor' then 'Tambores' else TE.Nome_Tp_Embal end) + 
			(case when inv_cli.linguagem = 'ESP' then ' de ' else ' of ' end) +
			convert(varchar(max),inv_det.Capacidade) + ' ' + 
			INV_DET.Tipo_Unid + 
			(case when inv_cli.linguagem = 'ESP' then ' cada uno' else ' each' end)
		from
			Invoice_Det Inv_Det
			Join Invoice_Cliente		Inv_CLI		on Inv_CLI.ID_Inv	=INV_DET.ID_Inv
			left join Tipo_Embalagem TE on TE.Cd_Tp_Embal = Inv_Det.Cd_Embalagem
			Left Join volume_exp_aer	VOL	on VOL.Num_Proc_HEA	=INV_CLI.Num_Proc and INV_DET.Item = Convert(Int,VOL.Item_EA)
			left join Tipo_Embalagem VE on VE.Cd_Tp_Embal 	= VOL.Cd_Tp_Embal
		where
			Inv_Det.ID_Inv = @ID_INV

		UNION
		Select
			convert(varchar(max),VOL.qtd_Vol_EO) + ' ' +
			VE.Nome_Tp_Embal + 
			(case when inv_cli.linguagem = 'ESP' then ' con ' else ' with ' end) +
			convert(varchar(max),Inv_Det.Quantidade) + ' ' +
			(case when TE.Nome_Tp_Embal = 'Tambor' then 'Tambores' else TE.Nome_Tp_Embal end) + 
			(case when inv_cli.linguagem = 'ESP' then ' de ' else ' of ' end) +
			convert(varchar(max),inv_det.Capacidade) + ' ' + 
			INV_DET.Tipo_Unid + 
			(case when inv_cli.linguagem = 'ESP' then ' cada uno' else ' each' end)
		from
			Invoice_Det Inv_Det
			Join Invoice_Cliente		Inv_CLI		on Inv_CLI.ID_Inv	=INV_DET.ID_Inv
			left join Tipo_Embalagem TE on TE.Cd_Tp_Embal = Inv_Det.Cd_Embalagem
			Left Join volume_exp_out	VOL	on VOL.Num_Proc_HEO	=INV_CLI.Num_Proc --and INV_DET.Item = Convert(Int,VOL.Item_EO)
			left join Tipo_Embalagem VE on VE.Cd_Tp_Embal 	= VOL.Cd_Tp_Embal
		where
			Inv_Det.ID_Inv = @ID_INV
			

		UNION
			Select
			convert(varchar(max),VOL.qtd_Vol_EM) + ' ' +
			VE.Nome_Tp_Embal + 
			(case when inv_cli.linguagem = 'ESP' then ' con ' else ' with ' end) +
			convert(varchar(max),Inv_Det.Quantidade) + ' ' +
			(case when TE.Nome_Tp_Embal = 'Tambor' then 'Tambores' else TE.Nome_Tp_Embal end) + 
			(case when inv_cli.linguagem = 'ESP' then ' de ' else ' of ' end) +
			convert(varchar(max),inv_det.Capacidade) + ' ' + 
			INV_DET.Tipo_Unid + 
			(case when inv_cli.linguagem = 'ESP' then ' cada uno' else ' each' end)
		from
			Invoice_Det Inv_Det
			Join Invoice_Cliente		Inv_CLI		on Inv_CLI.ID_Inv	=INV_DET.ID_Inv
			left join Tipo_Embalagem TE on TE.Cd_Tp_Embal = Inv_Det.Cd_Embalagem
			Left Join volume_exp_mar	VOL		on VOL.Num_Proc_HEM	=INV_CLI.Num_Proc and INV_DET.Item = Convert(Int,VOL.Item_EM)
			left join Tipo_Embalagem VE on VE.Cd_Tp_Embal 	= VOL.Cd_Tp_Embal
		where
			Inv_Det.ID_Inv = @ID_INV
			
		--IMPORTAÇÃO
		UNION

			Select
			convert(varchar(max),isnull(VOL.qtd_Vol_IM,VOLA.qtd_Vol_IA)) + ' ' +
			VE.Nome_Tp_Embal + 
			(case when inv_cli.linguagem = 'ESP' then ' con ' else ' with ' end) +
			convert(varchar(max),Inv_Det.Quantidade) + ' ' +
			(case when TE.Nome_Tp_Embal = 'Tambor' then 'Tambores' else TE.Nome_Tp_Embal end) +  + 
			(case when inv_cli.linguagem = 'ESP' then ' de ' else ' of ' end) +
			convert(varchar(max),inv_det.Capacidade) + ' ' + 
			INV_DET.Tipo_Unid + 
			(case when inv_cli.linguagem = 'ESP' then ' cada uno' else ' each' end)
		from
			Invoice_Det Inv_Det
			Join Invoice_Cliente		Inv_CLI		on Inv_CLI.ID_Inv	=INV_DET.ID_Inv
			left join Tipo_Embalagem TE on TE.Cd_Tp_Embal = Inv_Det.Cd_Embalagem
			Left Join volume_imp_mar	VOL		on VOL.Num_Proc_HIM	=INV_CLI.Num_Proc
			Left Join volume_imp_aer	VOLA	on VOLA.Num_Proc_HIA	=INV_CLI.Num_Proc
			left join Tipo_Embalagem VE on VE.Cd_Tp_Embal 	= isnull(VOL.Cd_Tp_Embal,VOLA.Cd_Tp_Embal)
		where
			Inv_Det.ID_Inv = @ID_INV


----------------------------------------------------------------------------
		open Cur_ID
			Fetch Next From Cur_ID Into @ID
			While @@FETCH_STATUS = 0
			Begin
				if @N_ID='' or @N_ID is Null
					Begin
						Set @N_ID=@ID
					end
				else
					begin
						set @N_ID=@N_ID + 
						(case when @Idioma = 'ESP' then ' y ' else ' and ' end)  + @ID
					end
				
				Fetch Next From Cur_ID Into @ID
			end
		close Cur_ID
		deallocate Cur_ID 
		
	return @N_ID
	
END

















GO
