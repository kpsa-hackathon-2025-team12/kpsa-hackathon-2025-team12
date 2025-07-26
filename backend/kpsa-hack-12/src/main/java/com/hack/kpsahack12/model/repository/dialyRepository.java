package com.hack.kpsahack12.model.repository;

import com.hack.kpsahack12.model.entity.member.dialy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface dialyRepository extends JpaRepository<dialy,Long> {
}
