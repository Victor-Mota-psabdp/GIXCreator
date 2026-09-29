SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE      Procedure spEvoCliente_rel
		@datainicial 	varchar(10),
		@datafinal	varchar(10),
		@pessoa		varchar(30),
		@Modal		varchar(2)


AS	
if @modal='IA'
	BEGIN
		select  
			apelido,cd_usuario,sum(qtd_tot_vol_hia) as Volume,sum(peso_real_hia) as Peso,  month(convert(datetime, eta_hia, 105)) as Mes, year(convert(datetime, eta_hia, 105)) as Ano, count(num_proc_hia) as Embarque, cd_tp_grupo from house_imp_aer
			
		inner join pessoa as cliente on (cd_pes=cd_import_hia)

		where 
			left(num_proc_hia,5)<>'IAJOB' and 
			convert(datetime, eta_hia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and apelido like @pessoa

		group by 

		cd_usuario,month(convert(datetime, eta_hia, 105)), year(convert(datetime, eta_hia, 105)), apelido, cd_tp_grupo
	END
ELSE

	if @modal='EA'
		BEGIN

			select  
				apelido,cd_usuario,sum(qtd_tot_vol_hea) as Volume,sum(peso_real_hea) as Peso,  month(convert(datetime, mas.dt_saida_mea, 105)) as Mes, year(convert(datetime, mas.dt_saida_mea, 105)) as Ano, count(num_proc_hea) as Embarque, cd_tp_grupo from house_exp_aer
				
			inner join pessoa as cliente on (cd_pes=cd_export_hea)
			inner join master_exp_aer as mas on (mas.num_proc_mea=house_exp_aer.num_proc_mea)

			where 
				left(num_proc_hea,5)<>'EAJOB' and 
				convert(datetime, dt_saida_mea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
				and apelido like @pessoa

			group by 
				month(convert(datetime, dt_saida_mea, 105)), year(convert(datetime, dt_saida_mea, 105)), apelido, cd_tp_grupo,cd_usuario
		END	
	
	ELSE
		if @modal='IM'
			Begin
				select  
					apelido,cd_usuario,sum(qtd_tot_vol_him) as Volume,sum(peso_bruto_him) as Peso,  month(convert(datetime, dt_atrac_mim, 105)) as Mes, year(convert(datetime, mas.dt_atrac_mim, 105)) as Ano, count(num_proc_him) as Embarque,  cd_tp_grupo from house_imp_mar as hou

				inner join pessoa as cliente on (cd_pes=cd_import_him)
				inner join master_imp_mar as mas on (hou.num_proc_mim=mas.num_proc_mim)
				where 
					left(num_proc_him,5)<>'IMJOB' and 
					convert(datetime, dt_atrac_mim, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
					and apelido like @pessoa

				group by 

					cd_usuario,month(convert(datetime, dt_atrac_mim, 105)), year(convert(datetime, dt_atrac_mim, 105)), apelido, cd_tp_grupo
			end

		else
			Begin
				select  
					apelido,cd_usuario,sum(qtd_tot_vol_hem) as Volume,sum(peso_liquido_hem) as Peso,  month(convert(datetime, mas.dt_saida_mem, 105)) as Mes, year(convert(datetime, mas.dt_saida_mem, 105)) as Ano, count(num_proc_hem) as Embarque,  cd_tp_grupo from house_exp_mar

				inner join pessoa as cliente on (cd_pes=cd_export_hem)
				inner join master_exp_mar as mas on (mas.num_proc_mem=house_exp_mar.num_proc_mem)

				where 
	
					left(num_proc_hem,5)<>'EMJOB' and 
					convert(datetime, dt_saida_mem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
					and apelido like @pessoa

				group by 
					cd_usuario,month(convert(datetime, dt_saida_mem, 105)), year(convert(datetime, dt_saida_mem, 105)), apelido, cd_tp_grupo

			end				







GO
